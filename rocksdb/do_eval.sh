#!/bin/bash

COMMON="../common"
source $COMMON/eval_nvmev.sh

MNT="/mnt/nvme"
NR_KEYS=200000000
#NR_KEYS=150000000
NR_THREADS=32
OUTPUT_DIR="/home/beowulf/nvmev-eval/rocksdb/results"

DB_BENCH_PARAMS="
	--db=$MNT/db \
	--wal_dir=$MNT/wal \
	--num=$NR_KEYS \
	--num_levels=6 \
	--key_size=10 \
	--value_size=1200 \
	--block_size=4096 \
	--cache_size=17179869184 \
	--cache_numshardbits=6 \
	--compression_max_dict_bytes=0 \
	--compression_ratio=0.5 \
	--compression_type=zstd \
	--level_compaction_dynamic_level_bytes=false \
	--bytes_per_sync=8388608 \
	--cache_index_and_filter_blocks=0 \
	--pin_l0_filter_and_index_blocks_in_cache=1 \
	--benchmark_write_rate_limit=0 \
	--hard_rate_limit=3 \
	--rate_limit_delay_max_milliseconds=1000000 \
	--write_buffer_size=134217728 \
	--target_file_size_base=134217728 \
	--max_bytes_for_level_base=1073741824 \
	--verify_checksum=1 \
	--delete_obsolete_files_period_micros=62914560 \
	--max_bytes_for_level_multiplier=8 \
	--statistics=0 \
	--stats_per_interval=1 \
	--stats_interval_seconds=60 \
	--histogram=1 \
	--memtablerep=skip_list \
	--bloom_bits=10 \
	--open_files=-1 \
	--max_background_compactions=16 \
	--max_write_buffer_number=8 \
	--max_background_flushes=7 \
	--seed=1547765340 \
"

function do_init() {
	sudo umount $MNT > /dev/null 2>&1
	sudo service postgresql stop > /dev/null 2>&1
	sudo umount /var/lib/postgresql > /dev/null 2>&1

	sudo mkfs.ext4 -F /dev/$DEV || exit
	sudo mount /dev/$DEV $MNT || exit
	sudo chown beowulf:beowulf $MNT || exit

	$COMMON/set_perf_exact.sh 1 1 256 12

	cd benchmark
	./db_bench $DB_BENCH_PARAMS \
			--benchmarks=fillrandom \
			--use_existing_db=0 \
			--disable_auto_compactions=1 \
			--sync=0 \
			--threads=1 \
			--allow_concurrent_memtable_write=false \
			--level0_file_num_compaction_trigger=10485760 \
			--level0_slowdown_writes_trigger=10485760 \
			--level0_stop_writes_trigger=10485760 \
			--memtablerep=vector \
			--disable_wal=1
	cd ..
}


function do_test() {
	cd benchmark
	./db_bench $DB_BENCH_PARAMS \
			--benchmarks=readwhilewriting \
			--use_existing_db=1 \
			--sync=1 \
			--threads=$NR_THREADS \
			--level0_file_num_compaction_trigger=4 \
			--level0_stop_writes_trigger=20 \
			--merge_operator="put" \
			--duration 1800 \
			2>&1 | tee -a $OUTPUT_DIR/benchmark-$1-$2-$3.log

	cd ..
}

do_init

$COMMON/set_perf.sh $1 $2 $3
eval_nvmev $1 $2 $3
