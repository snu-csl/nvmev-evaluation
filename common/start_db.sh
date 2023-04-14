#!/bin/bash
DEV=/dev/$1
DB_ENGINE=$2

if [ $# -ne 2 ]; then
	echo "Usage: $0 [NVMe device path] [mysql | psql | mdb]"
	exit
fi

if [ ! -b $DEV ]; then
	echo "Device $DEV does not exist"
	exit
fi

if [ $2 == "mysql" ]; then
	DB_ENGINE="mysql"
elif [ $2 == "psql" ]; then
	DB_ENGINE="postgresql"
elif [ $2 == "mdb" ]; then
	DB_ENGINE="mongodb"
else
	echo "$2 is not supported."
	exit
fi

sudo service ${DB_ENGINE} stop
sudo umount /var/lib/${DB_ENGINE}
sudo mount ${DEV} /var/lib/${DB_ENGINE}
#sudo mount -o discard ${DEV} /var/lib/${DB_ENGINE}

#DB_CPU_SET="0x55555555" # 0,2,4,6,8,10,12,14,16,18,20,22,24,26,28,30 on csl
DB_CPU_SET="-c 0-17,36-53" # on echo

echo -n "Starting DBMS for ${DB_ENGINE}... "
if [ ${DB_ENGINE} == "mysql" ]; then
	sudo service ${DB_ENGINE} start || exit
	DB_PID=`sudo systemctl status mariadb.service | grep "Main PID" | cut -d' ' -f 4`
	sudo taskset -a -p ${DB_CPU_SET} ${DB_PID}

elif [ ${DB_ENGINE} == "postgresql" ]; then
	sudo service ${DB_ENGINE} start || exit
	for pid in `ps -Te | grep postgres | awk '{print $2}'`; do
		sudo taskset -a -p ${DB_CPU_SET} $pid
	done

elif [ ${DB_ENGINE} == "mongodb" ]; then
	sudo service ${DB_ENGINE} start || exit
	for pid in `ps -Te | grep mongod | awk '{print $2}'`; do
		sudo taskset -a -p ${DB_CPU_SET} $pid
	done
fi
