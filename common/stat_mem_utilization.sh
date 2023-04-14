#!/bin/bash

rm -rf memstat 

while [ 1 ]; do
	sh -c "date; vmstat | tail -1; echo" >> memstat
	sleep 1
done
