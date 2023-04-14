#!/bin/bash

nvme_nr=`lspci | grep "Non-Volatile memory controller" | cut -d' ' -f1`
for id in $nvme_nr
do
	trans_id=`echo $id | sed 's/:/\\:/g'`
	sudo sh -c "echo 1 > /sys/bus/pci/devices/0000\:${trans_id}/remove"
done
