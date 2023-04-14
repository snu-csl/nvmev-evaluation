#!/bin/bash

COMMON="../common"
source $COMMON/eval_nvmev.sh

function do_test() {
	cd benchmark
	./bin/linkbench -c config/MyConfig.properties \
		-csvstats ../results/stats-$1-$2-$3.csv \
		-csvstream ../results/stream-$1-$2-$3.csv \
		-L ../results/linkbench-$1-$2-$3.log \
		-r
	cd ..
}

eval_nvmev $1 $2 $3
