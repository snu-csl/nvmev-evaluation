#!/bin/bash
OUTPUT="nvstat"

rm -rf $OUTPUT

while [ 1 ]
do
	CUR=`date`
	STAT=`cat /proc/nvmev/stat`
	echo $CUR $STAT >> $OUTPUT
	sleep 1
done
