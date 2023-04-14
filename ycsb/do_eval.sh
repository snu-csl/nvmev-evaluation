#!/bin/bash

if [ -z ${DEV} ]; then
	DEV="nvme3n1"
	echo "WARNING: DEV is not defined. Use default device, which is $DEV"
fi

DB_PATH="/mnt/nvme/"
DB_SRC_PATH="/mnt/rocksdb/"

WORKLOAD="../workloads/$4"

YCSB_PROPERTIES="-p rocksdb.dir=${DB_PATH} -p rocksdb.optionsfile=../rocksdb-options.ini -p maxexecutiontime=1800 -p status.interval=1"

COMMON="../common"
source $COMMON/eval_nvmev.sh

function do_collect() {
	mv result results/result-$1-$2-$3
	mv iostat results/iostat-$1-$2-$3
	mv nvstat results/nvstat-$1-$2-$3
	mv cpustat results/cpustat-$1-$2-$3
	mv ${DB_PATH}/LOG results/log-$1-$2-$3
}

function do_init() {
	sudo umount ${DB_PATH}
	sudo mkfs.ext4 -F /dev/${DEV}
	sudo mount /dev/${DEV} ${DB_PATH}
	sudo chown beowulf:beowulf ${DB_PATH}
	rsync -av ${DB_SRC_PATH} ${DB_PATH}

#	cd benchmark
#	./bin/ycsb load rocksdb -s -P ${WORKLOAD} ${YCSB_PROPERTIES}
#	cd ..

	${COMMON}/drop_cache.sh
}

function do_test() {
	cd benchmark
	./bin/ycsb run rocksdb -s -P ${WORKLOAD} ${YCSB_PROPERTIES}
	cd ..
}

do_init

eval_nvmev $1 $2 $3
