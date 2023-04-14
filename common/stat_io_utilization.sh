#!/bin/bash

rm -rf iostat

while [ 1 ]; do
	sh -c "date; cat /proc/diskstats; echo" >> iostat
	sleep 1
done
