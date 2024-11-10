LLVM_MOS?=~/llvm-mos
BYPASS?=1

CLANG?=$(LLVM_MOS)/bin/mos-common-clang
NM?=$(LLVM_MOS)/bin/llvm-nm
PYTHON?=python
FDSPACKER?=./fdspacker

OUTPUT_IMAGE?=output.fds
EXECUTABLE=main.prg
EXECUTABLE_ELF=main.prg.elf
SOURCE=main.c
CRT0=crt0.c
VECTORS=vectors.bin
CHR=Alpha.chr

all: $(OUTPUT_IMAGE)

build: $(OUTPUT_IMAGE)

$(EXECUTABLE): $(SOURCE) $(CRT0)
	$(CLANG) $(SOURCE) $(CRT0) -o $(EXECUTABLE) -Os -lexit-loop -flto

$(VECTORS): $(EXECUTABLE)
	$(NM) $(EXECUTABLE_ELF) | $(PYTHON) vectorgen.py -b$(BYPASS)

$(OUTPUT_IMAGE): $(EXECUTABLE) $(VECTORS) diskinfo.json
	$(FDSPACKER) pack --header diskinfo.json $(OUTPUT_IMAGE)

clean:
	rm -f $(EXECUTABLE) $(OUTPUT_IMAGE)

.PHONY: clean
