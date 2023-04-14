#!/bin/bash
if [ -z $DEV ]; then
	DEV="nvme2n1"
fi
JOBS=1
DEPTH=1

COMMON="../common"
source ${COMMON}/eval_nvmev.sh

if [ $# -ne 4  ]; then
	echo "Usage $0 [read latency in us] [write latency in us] [nr_slots] [workload]"
	exit
fi

function do_test() {
	sudo DEV="/dev/${DEV}" JOBS=${JOBS} DEPTH=${DEPTH} \
		fio workloads/$4.fio
}

function do_collect() {
	mv result results/result-$4-$1-$2-$3
	mv iostat results/iostat-$4-$1-$2-$3
	mv cpustat results/cpustat-$4-$1-$2-$3
	mv nvstat results/nvstat-$4-$1-$2-$3
}

eval_nvmev $1 $2 $3 $4
