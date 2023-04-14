#!/bin/sh

if [ $# -lt 1 ]; then
    echo "Usage: $0 [scale] {data path}"
    exit 1
fi

ROOT=$(dirname $(readlink -f $0))
TPCH_HOME=${ROOT}/tpch-tools
DATA=${ROOT}/data

if [ $# -ge 2 ]; then
	DATA=$2
fi

cd ${TPCH_HOME}/dbgen

make -f makefile.suite all || exit

rm -rf *.tbl *.csv ${DATA}

# generate data
./dbgen -f -s $1

mkdir -p ${DATA}
for i in `ls *.tbl`; do
  # remove last delimiter '|'
  sed 's/|$//' $i > ${DATA}/${i%.tbl}.csv
done
