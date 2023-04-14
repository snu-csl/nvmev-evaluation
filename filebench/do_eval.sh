#!/bin/bash
COMMON="../common"
source "$COMMON/eval_nvmev.sh"

TARGET="/mnt/nvme"
DEV=nvme3n1

function do_init() {
	sudo sh -c "echo 0 > /proc/sys/kernel/randomize_va_space"

	sudo umount $TARGET
	sudo mkfs.ext4 -F /dev/$DEV || exit
	sudo mount /dev/$DEV $TARGET || exit
}

function do_test() {
	sudo filebench -f $4
}

do_init

eval_nvmev $1 $2 $3 $4
