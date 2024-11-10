/* Provide imaginary (zero page) registers. */
__rc0 = 0x10;
INCLUDE imag-regs.ld
ASSERT(__rc0 == 0x10, "Inconsistent zero page map.")
ASSERT(__rc31 == 0x2f, "Inconsistent zero page map.")

MEMORY {
    zp : ORIGIN = __rc31 + 1, LENGTH = 0x100 - (__rc31 + 1)
    ram (rw) : ORIGIN = 0x6000, LENGTH = 0x7ff6
}

REGION_ALIAS("c_readonly", ram)
REGION_ALIAS("c_writeable", ram)

SECTIONS {
  .text : {
       INCLUDE text-sections.ld
       *(.nmi_begin)
       *(SORT_BY_INIT_PRIORITY(.nmi.* .nmi))
       *(.nmi_end)
  } >c_readonly
  INCLUDE rodata.ld
  /* A naturally page-aligned place (0x200) to place noinit buffers with high
   * alignment requirement (e.g. OAM) */
  .aligned (NOLOAD) : { *(.aligned .aligned.*) } >ram
  INCLUDE data.ld
  INCLUDE zp.ld
  INCLUDE bss.ld
  INCLUDE noinit.ld

  .ram (NOLOAD) : { *(.ram .ram.*) } > ram

  .vector : { SHORT(nmi) SHORT(_start) SHORT(irq) } > ram
}

OUTPUT_FORMAT { TRIM(ram) }