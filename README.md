# Fyne Cross Images

fyne-cross is a simple tool to cross compile and create distribution packages
for [Fyne](https://fyne.io) applications using docker images that include Linux,
the MinGW compiler for Windows, FreeBSD, and a macOS SDK, along with the Fyne
requirements.

This project provides the docker images required by fyne-cross to cross compile.

## Requirements

- docker

## Supported targets

Table below reports the status of `fyne-cross`'s supported cross compilation targets.
The supported architectures for the host are `amd64`and `arm64`. 

|                | amd64              | arm64 |
| -------------- | ------------------ | ----- |
| darwin/amd64   | :white_check_mark: | :white_check_mark: |
| darwin/arm64   | :white_check_mark: | :white_check_mark: |
| linux/amd64    | :white_check_mark: | :white_check_mark: |
| linux/386      | :white_check_mark: | :white_check_mark: |
| linux/arm      | :white_check_mark: | :white_check_mark: |
| linux/arm64    | :white_check_mark: | :white_check_mark: |
| windows/amd64  | :white_check_mark: | :white_check_mark: |
| windows/386    | :white_check_mark: | :white_check_mark: |

> Note: 
> - darwin images should work out of the box against MacOSX SDKs 11.3. 
> Other SDK versions could require a different min SDK version that can specified using the `--macosx-version-min` flag

## Building container with darwin sdk included

In some case, you might want to build your own container and include the darwin sdk in it. A solution to this is to use
`fyne-cross darwin-sdk-extract` command and copy the sdk you want in the subdirectory `darwin-with-sdk/sdk`. You can then use
the Makefile to build that new container. If you do not need to rebuild the `base` and `darwin` container, just reusing the
upstream version, you can do so by creating the appropriate `.`file that match the Makefile and the builder you are using to
create your image. For example: `touch .docker-base .docker-darwin` if you are using docker with the multi architecture Makefile.

## Fix illegal feature 

When build darwin sdk extract in GitHub action. Errors happened due to CPU not fit Zig requirement.

```
#20 256.2 Illegal instruction at address 0x1150f40
#20 256.3 /usr/local/zig/lib/std/zig/system/linux.zig:378:5: 0x1150f40 in detectNativeCpuAndFeatures (build)
#20 256.3     return asm ("mrs %[ret], " ++ feat_reg
```

We need to use our own server to run as a runner.

## Fix multiplie platform docker build 

https://unix.stackexchange.com/questions/748633/error-multiple-platforms-feature-is-currently-not-supported-for-docker-driver

