# Example of compiling C for FDS using llvm-mos
This is a small, hacked-together version of [nesdoug](https://nesdoug.com)'s "Hello World" example in C that targets the Famicom Disk System using the llvm-mos toolchain.

## Differences and notes
Instead of the `nes` target, the `common` target is used. This is because the executable output is less like an INES ROM and (somewhat) more like an executable from a home computer of the era, and the libraries (including crt0/libcrt0) that the `nes` target uses by default are missing instructions that are needed when running on FDS.

As such, the `crt0.c` and `nes.h` files are copied and modified from llvm-mos-sdk; while the `nes.h` file is mostly unmodified (with the exception of removing the color defines due to a conflict), the `crt0.c` file has been modified to set the FDS to use vertical mirroring on init/reset and add the license bypass code.

This uses the license bypass trick by default. If you wish to not use this and instead use the normal FDS load functionality that shows the license screen after loading, you'll need to extract the `KYODAKU-` file from a disk and then modify `diskinfo.json` to add the following to `files`, adjusting the `file_number`, `file_indicate_code`, and `data` fields accordingly:
```json
{
  "file_number": "3",
  "file_indicate_code": "3",
  "file_name": "KYODAKU-",
  "file_address": "$2800",
  "file_kind": "NameTable",
  "data": "kyodaku.bin"
}
```
After that, set `file_amount` to the actual number of files on disk and modify the Makefile to change `BYPASS` from 1 to 0.

## Building
Requirements:
- `make`
- The [llvm-mos](https://llvm-mos.org) toolchain
- [Python 3](https://python.org)
- [FDSPacker](https://github.com/ClusterM/fdspacker)

You may need to edit the Makefile to specify the paths to each executable. Afterwards, you should be able to build it like any other Makefile-based project:
```sh
$ make
```

## Credits
Thanks go out to the following:
- [ClusterM](https://github.com/ClusterM), for FDSPacker and [DupliFDS](https://github.com/ClusterM/duplifds) (which demonstrates how FDSPacker can be used when building a project)
- [rainwarrior](https://rainwarrior.ca), for their [minimal ca65 FDS example](https://github.com/bbbradsmith/NES-ca65-example/tree/fds) that uses the license bypass trick
- [nesdoug](https://nesdoug.com), for his in-depth NES C development tutorial series
- The [llvm-mos](https://llvm-mos.org) team and contributors (because of course!)
