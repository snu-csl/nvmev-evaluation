#!/bin/bash

#sudo killall stat_cpu_utilization.sh &> /dev/null
#sudo killall stat_io_utilization.sh &> /dev/null
#sudo killall stat_nvmev.sh &> /dev/null

PIDS=`ps -u \`whoami\` | grep stat_ | awk '{print $1}'`

for p in $PIDS; do
	sudo kill $p &> /dev/null
done

sudo killall mpstat &> /dev/null
