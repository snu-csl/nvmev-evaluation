#!/bin/bash
ROOT=$(dirname $(readlink -f $0))
source ${ROOT}/../../common/config

DBNAME=${DB_TPCH}

# log
LOGFILE=bench.log
RESULTS=${ROOT}/results

benchmark_dss() {
  print_log "- Running queries defined in TPC-H benchmark"

  for n in `seq 1 22`
  do
    q="${ROOT}/queries/$n.sql"

    if [ -f "$q" ]; then
      print_log "  running query $n"
      echo "RUNNING QUERY $n"
      # run explain
	  sh -c "echo 'set profiling=1;'; cat $q; echo 'show profiles'" | 
		  mysql -u $MYSQL_USER --password="$MYSQL_PASSWD" $DBNAME > $RESULTS/result-$n 2> $RESULTS/error-$n
    fi;

  done;
}

print_log() {
  message=$1
  echo `date +"%Y-%m-%d %H:%M:%S"` "["`date +%s`"] : $message" >> $RESULTS/$LOGFILE;
}

rm -rf $RESULTS
mkdir -p $RESULTS

print_log "Running TPC-H benchmark"
benchmark_dss
print_log "Finished TPC-H benchmark"
