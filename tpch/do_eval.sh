#!/bin/bash

COMMON="../common"
source $COMMON/eval_nvmev.sh

TARGET=postgres

if [[ $TARGET == "mariadb" ]]; then
	DB_CMD="mysql -u $MYSQL_USER --password=\"$MYSQL_PASSWD\" $DB_TPCH"
elif [[ $TARGET == "postgres" ]]; then
	DB_CMD="psql $DB_TPCH"
fi

function do_collect_x() {
	# Override this function to change file names
	mv result results/result-$1-$2-$3
	mv iostat results/iostat-$1-$2-$3
	mv nvstat results/nvstat-$1-$2-$3
	mv cpustat results/cpustat-$1-$2-$3
}

function do_test() {
	mkdir -p results
	for n in `seq 1 22`; do
		query="$TARGET/queries/$n.sql"
		if [[ ! -f $query ]]; then
			continue;
		fi
		echo "** Query $n **"
		cat $query | $DB_CMD
		echo; echo;
	done
}

eval_nvmev $1 $2 $3
