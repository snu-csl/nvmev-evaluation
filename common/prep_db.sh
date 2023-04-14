##!/bin/bash

PWD=`dirname \`readlink -f $0\``

${PWD}/set_perf.py max

${PWD}/init_db.sh $1 $2 $3
${PWD}/start_db.sh $1 $2
