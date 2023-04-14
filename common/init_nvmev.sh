#!/bin/bash
PWD=`dirname \`readlink -f $0\``

if [ $# -ne 1 ]; then
	echo "Usage: $0 [NVMeVirt Path]"
	exit
fi

if [ ! -f "$1/nvmev.ko" ]; then
	echo "NVMeVirt module does not exist at $1"
	exit
fi

echo
echo "Load NVMeVirt kernel module..."
sudo insmod $1/nvmev.ko \
	memmap_start=128G \
	memmap_size=64G   \
  	cpus=7,8    