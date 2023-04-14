#!/bin/bash

CPU_AFFINITY=0-17,36-53		# example

function do_test() {
	echo "*** Override do_test() function to evaluate NVMeVirt ***"
}

function do_collect() {
	# Override this function to change file names
	mv result results/result-$1-$2-$3
	mv iostat results/iostat-$1-$2-$3
	mv nvstat results/nvstat-$1-$2-$3
	mv cpustat results/cpustat-$1-$2-$3
}

function do_measure() {
	# Start measuring
	$COMMON/abort_eval.sh

	sudo sh -c "echo 0 > /proc/nvmev/stat"

	$COMMON/stat_cpu_utilization.sh &> /dev/null &
	$COMMON/stat_io_utilization.sh $DEV &> /dev/null &
	$COMMON/stat_nvmev.sh &> /dev/null &

	# Run actual test
	do_test $* 2>&1 | tee result

	# Finish collecting results
	for p in `jobs -p`; do
		for c in `pgrep -P $p`; do	# Kill children
			sudo sh -c "kill -9 $c"
		done
		sudo sh -c "kill -9 $p"
	done

	# Collect results
	mkdir -p results &> /dev/null
	do_collect $*
}

function eval_nvmev() {
	if [ $1 == "max" ]; then
		$COMMON/set_perf.py max
	elif [ $# -lt 3 ]; then
		echo "Usage $0 [read latency in us] [write latency in us] [io_units] ...."
		exit -1
	else
		$COMMON/set_perf.py $1 $2 $3
	fi

	echo "#########################################################"
	echo "###               NVMeVirt Evaluator                  ###"
	echo "#########################################################"
	echo "# read latency  : ${1} us"
	echo "# write latency : ${2} us"
	echo "# bandwidth     : ${3} MB/s"
	echo
	echo -n "Start measuring at "
	date

	taskset -p -c $CPU_AFFINITY $$ &> /dev/null
	sleep 1

	do_measure $*

	echo -n "Finish measuring at "
	date
	echo "# read latency  : ${1} us"
	echo "# write latency : ${2} us"
	echo "# io units      : ${3}"
	echo "#########################################################"
	echo; echo; echo; echo
}

source $COMMON/config
