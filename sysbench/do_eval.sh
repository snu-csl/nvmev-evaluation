#!/bin/bash

NR_THREADS=$((36*2))
DURATION_SEC=$((60*30))

COMMON="../common"
source "$COMMON/eval_nvmev.sh"

DB_TYPE=mysql # mysql or pgsql

DB_PARAMS="--db-driver=$DB_TYPE --$DB_TYPE-db=$DB_SYSBENCH
	--$DB_TYPE-host=localhost --$DB_TYPE-user=nvmevirt --$DB_TYPE-password=$DB_PASSWD"

function do_test() {
	sysbench /usr/share/sysbench/oltp_read_write.lua \
		--tables=10 --table-size=50000000 \
		--threads=$NR_THREADS --time=$DURATION_SEC \
		$DB_PARAMS --histogram --percentile=99 --report-interval=1 \
		run
}

eval_nvmev $1 $2 $3
