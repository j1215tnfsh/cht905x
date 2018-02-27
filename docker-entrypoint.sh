#!/bin/bash

set -e
CMD=$1
GCC_ARM_NONE_EABI=/opt/aml_toolchains/gcc-arm-none-eabi-6-2017-q2-update/bin
GCC_LINARO_AARCH64_LINUX_GNU=/opt/aml_toolchains/gcc-linaro-aarch64-linux-gnu-4.9-2014.09_linux/bin
GCC_LINARO_AARCH64_NONE_ELF=/opt/aml_toolchains/gcc-linaro-aarch64-none-elf-4.8-2013.11_linux/bin
GCC_LINARO_ARM_LINUX_GNUEABIHF=/opt/aml_toolchains/gcc-linaro-arm-linux-gnueabihf/bin
export PATH=$GCC_ARM_NONE_EABI:$GCC_LINARO_AARCH64_LINUX_GNU:$GCC_LINARO_AARCH64_NONE_ELF:$GCC_LINARO_ARM_LINUX_GNUEABIHF:$PATH
if [ "$CMD" = "root" ]; then
    exec bash
fi

if mount | grep "on /src" >/dev/null 2>&1; then
    USER_ID=$(stat -c %u /src)
    USER_NAME=user_$USER_ID
    if ! id -u $USER_NAME >/dev/null 2>&1; then
        useradd -m -u $USER_ID $USER_NAME
    fi
else
    echo "need to have a /src mount"
    exit -1
fi

export USER=$USER_NAME
if [ "$CMD" = "user" ]; then
    set -- bash
fi
exec gosu $USER_NAME "$@"