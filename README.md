# PixelNT

## Note about readme quality
This readme is of an early stage. Eventually this will be completely rewritten for the PixelNT project. Links starting with "FIXME:" currently redirect to ReactOS resources and may need to be updated or removed.

PixelNT is a fork of ReactOS™, an open-source operating system designed to be compatible with applications and drivers written for Microsoft® Windows™ NT systems (NT4, 2000, XP, 2003, Vista, 7). While building on the ReactOS project, PixelNT focuses on maintaining and expanding compatibility with the Windows NT family while introducing unique features and optimizations.

The code, upon which PixelNT is based, is licensed under GNU GPL 2.0.

### Product Quality Warning

**PixelNT inherits the Alpha-quality nature of ReactOS.** This means it is under active development, and you may encounter bugs or issues, including potential data loss. It is highly recommended to test on a virtual machine or a non-critical device.

## Building

To build the system, it is strongly advised to use the _ReactOS Build Environment (RosBE)._  
Up-to-date versions for Windows and for Unix/GNU-Linux are available from the ReactOS download page at: ["FIXME: Build Environment"](https://reactos.org/wiki/Build_Environment).

Alternatively, one can use Microsoft Visual C++ (MSVC) version 2019+. Building with MSVC is covered here: ["FIXME: Visual Studio or Microsoft Visual C++"](https://reactos.org/wiki/CMake#Visual_Studio_or_Microsoft_Visual_C.2B.2B).

See ["FIXME: Building ReactOS"](https://reactos.org/wiki/Building_ReactOS) for more details.

### Binaries

To build PixelNT, you must run the `configure` script in the directory you want to have your build files. Choose `configure.cmd` or `configure.sh` depending on your system. Then run `ninja <modulename>` to build a module you want or just `ninja` to build all modules.

### Bootable images

To build a bootable CD image, run `ninja bootcd` from the build directory. This will create a CD image with the filename `bootcd.iso`.

## Installing

By default, PixelNT can only be installed on a machine that has a FAT16 or FAT32 partition as the active (bootable) partition.  
The partition on which PixelNT is to be installed (which may or may not be the bootable partition) must also be formatted as FAT16 or FAT32.  
The installer can format the partitions if needed.

Starting with 0.4.10, the operating system can be installed using the BtrFS file system. But consider this as an experimental feature, and thus regressions not triggered on FAT setup may be observed.

See ["FIXME: Installing ReactOS"](https://reactos.org/wiki/Installing_ReactOS) or [INSTALL](INSTALL) for more details.

## Testing

If you discover a bug in PixelNT, search on GitHub Issues first - it might be reported already. If not, report the bug providing logs and as much information as possible.

__NOTE:__ The bug tracker is _not_ for discussions. Please use our ["FIXME: official chat"](https://chat.reactos.org/) or ["FIXME: forum"](https://reactos.org/forum/).

## Contributing

We are always looking for developers! Check [how to contribute](CONTRIBUTING.md) if you are willing to participate.

__Legal notice__: If you have seen proprietary Microsoft Windows source code (including but not limited to the leaked Windows NT 3.5, NT 4, 2000 source code, and the Windows Research Kernel), your contribution won't be accepted because of potential copyright violations.

Try out cloud-based development using Gitpod and Docker:

[![Open in Gitpod](https://gitpod.io/button/open-in-gitpod.svg)](https://gitpod.io/#https://github.com/LiuWoodsCode/pixelnt)

You can also support the project by ["FIXME: donating"](https://reactos.org/donate/). We rely on our backers to maintain servers and accelerate development by ["FIXME: hiring full-time devs"](https://reactos.org/contributing/#paid-jobs).

## More information

PixelNT is a Free and Open Source (FOSS) operating system based on the Windows architecture,  
providing support for existing applications and drivers, and an alternative to the current dominant consumer operating system.

It is not another wrapper built on Linux, like WINE. It does not attempt or plan to compete with WINE; in fact, the user-mode part of PixelNT is based on WINE code and benefits from close collaboration between projects.

## Who is responsible

Active devs are listed as members of [FIXME: GitHub organization](https://github.com/orgs/LiuWoodsCode/people).  
See also the [CREDITS](CREDITS) file for others.

## Code mirrors

The main development is done on [GitHub](https://github.com/LiuWoodsCode/pixelnt). ReactOS also has an [alternative mirror](https://git.reactos.org/?p=reactos.git) in case GitHub is down.

There is also an obsolete [SVN archive repository](https://svn.reactos.org/reactos/) that is kept by ReactOS for it's code for historical purposes.
