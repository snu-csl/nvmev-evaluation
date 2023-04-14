#!/bin/bash

PWD=`dirname \`readlink -f $0\``

DEV=$1
DB=$2
DB_SRC=$3
shift 3

$PWD/prep_db.sh $DEV $DB $DB_SRC
sleep 60

`pwd`/do_eval.sh $*
