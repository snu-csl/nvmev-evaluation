#!/bin/bash
NR_CPUS=`grep processor /proc/cpuinfo | wc -l`
#CPU_LIST=`seq -s "," 0 2 $((NR_CPUS-1))` # on csl1
CPU_LIST="0-17,36-53" # echo

taskset -c $((NR_CPUS-1)) mpstat -P $CPU_LIST 1 > cpustat
