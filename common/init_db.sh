#!/bin/bash
FS=ext4
FS_MOUNT_OPTIONS= #-o discard

function print_usage() {
	echo "Usage: $1 [Device name] [mysql | psql | mdb] [Path to DB backup]"
}

if [ $# -ne 3 ]; then
	print_usage $0
	exit
fi

if [ ! -b "/dev/$1" ]; then
	echo "Device /dev/$1 does not exist"
	exit
fi

if [[ $2 == "mysql" ]]; then
	DB_ENGINE="mysql"
	DB_USER="mysql:mysql"
elif [[ $2 == "psql" ]]; then
	DB_ENGINE="postgresql"
	DB_USER="postgres:postgres"
elif [[ $2 == "mdb" ]]; then
	DB_ENGINE="mongodb"
	DB_USER="mongodb:mongodb"
else
	echo "$0 supports mysql, postgres, and mongodb engines only"
	exit
fi

if [ ! -d "$3" ]; then
	echo "Source DB does not exist at $3"
	exit
fi

DEV="/dev/$1"
DB_SRC=$3
DB_PATH="/var/lib/${DB_ENGINE}"
PWD=`dirname \`readlink -f $0\``

echo "Make ${DB_ENGINE} DB instance on ${DEV} from ${DB_SRC}..."

echo "Drop the current database instance..."
sudo service ${DB_ENGINE} stop
sleep 5
sudo umount -f ${DB_PATH}
sudo rm -rf ${DB_PATH}
sudo mkdir -p ${DB_PATH}

echo "Making fresh database..."
if [[ $FS == "ext4" ]]; then
	sudo mkfs.ext4 -F ${DEV} || exit
elif [[ $FS == "xfs" ]]; then
	sudo mkfs.xfs -f ${DEV} || exit
	sudo xfs_repair -L ${DEV}
fi

sudo mount ${FS_MOUNT_OPTIONS} ${DEV} ${DB_PATH} || exit

sudo chown ${DB_USER} ${DB_PATH} || exit

sudo rsync -av ${DB_SRC}/ ${DB_PATH}/ || exit
sync
${PWD}/drop_cache.sh
echo "Done!!"
