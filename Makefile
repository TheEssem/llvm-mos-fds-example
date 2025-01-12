LLVM_MOS?=~/llvm-mos
BYPASS?=1

CC=$(LLVM_MOS)/bin/mos-common-clang
NM?=$(LLVM_MOS)/bin/llvm-nm
PYTHON?=python3
FDSPACKER?=./fdspacker
MESEN?=mesen2

OUTPUT_IMAGE?=output.fds
EXECUTABLE=main.prg
EXECUTABLE_ELF=main.prg.elf
SOURCE=main.c
CRT0=crt0.c
VECTORS=vectors.bin
CHR=Alpha.chr

all: $(OUTPUT_IMAGE)

build: $(OUTPUT_IMAGE)

run: $(OUTPUT_IMAGE)
	$(MESEN) $(OUTPUT_IMAGE)

$(EXECUTABLE): $(SOURCE) $(CRT0)
	$(CC) $(SOURCE) $(CRT0) -o $(EXECUTABLE) -Os -lexit-loop -flto

$(VECTORS): $(EXECUTABLE)
	$(NM) $(EXECUTABLE_ELF) | $(PYTHON) vectorgen.py -b$(BYPASS)

$(OUTPUT_IMAGE): $(EXECUTABLE) $(VECTORS) diskinfo.json
	$(FDSPACKER) pack --header diskinfo.json $(OUTPUT_IMAGE)

clean:
	rm -f $(EXECUTABLE) $(OUTPUT_IMAGE)

.PHONY: clean
