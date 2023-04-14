# Evaluation Suite for NVMe devices

## Introduction
This suite evaluates NVMe devices by running assorted storage benchmarks.


## Common
### Prerequisite
	$ sudo apt install sysstat	# To collecting CPU utilization stat

### Setup environment
- Some benchmarks are written in Java (e.g., Escada TPC-C), so setup `JAVA_HOME` in common/config. Setup other environmental varibles in the file as well.
	```shell
	$ vi common/config
	JAVA_HOME="/usr/lib/jvm/default-java"
	```

### Submodules
- Benchmarks are registered as a submodule in their corresponding directory.
	```shell
	$ git submodule init
	$ git submodule update
	```

### Setup mysql/mariadb
	$ sudo apt install mariadb-server mariadb-client

- The default mysql distribution in Debian stretch does not perform well due to the default setup. Refer to common/config/my.cnf which increases the buffer pool size.

- It is recommended to make .my.cnf in the home directory.
	```
	$ vi ~/.my.cnf

	[client]
	host=localhost
	user=nvmevirt
	password=mysecretpassword
	```


### Setup PostgreSQL

- Likewise mysql, postgresql does not work well with the default parameter neither. Refer to common/conf/postgresql.conf. Changes are;
	```propergies
	shared_buffers = 16384MB       # recommended 1/4 of memory
	checkpoint_segments = 256
	effective_cache_size = 32768MB # recommended 1/2 of memory

	max_locks_per_transaction = 256 # To resolve out of shared memory
	max_pred_locks_per_transaction = 256
	```

- Use following commands to initialize the database instance
	```shell
	$ createuser -s username	# Create user as a superuser
	$ createdb -O username databasename
	$ psql databasename
	\password
	\q
	```

- It is recommended to make .pgpass in the home directory, which looks like;
	```
	localhost:*:*:userid:password
	```

## Running Benchmarks

### Sysbench OLTP
- Sysbench 1.0.20
	```shell
	$ sudo apt install sysbench
	```


- Populate OLTP dataset with 10 tables with table size of 50,000,000 (~120 GB)
	```shell
	# For mariadb
	$ sysbench /usr/share/sysbench/oltp_common.lua \
		--db-driver=mysql --mysql_storage_engine=innodb \
		--mysql-host=localhost --mysql-db=sysbench --mysql-user=root --mysql-password=PASSWORD \
		--tables=10 --table-size=50000000
		prepare

	# For postgresql
	$ sysbench /usr/share/sysbench/oltp_common.lua
		--db-driver=pgsql \
		--pgsql-host=localhost --pgsql-db=sysbench --pgsql-user=root --pgsql-password=PASSWORD \
		--tables=10 --table-size=50000000 \
		prepare
	```


### Filebench
- Benchmark available at https://github.com/filebench/filebench
- Change the maximum files in `ipc.h` to 1024 * 1024 * 16 to support a huge number of files.
- varmail.f
	- nfiles is increased to 8000000 (~150 GB)
	- Threads are increased to 128 from 16
	- Run for 1800 secs (30 mins)

- webserver.f
	- nfiles is increased to 8000000 (~150 GB)
	- Threads are increased to 256 from 100
	- Run for 1800 secs (30 mins)


### Linkbench
- Facebook Linkbench (https://github.com/facebookarchive/linkbench)

- Run with mariadb/mysql

- Setup
	- Initialize the submodule
	- Setup DB connection by copying `config/LinkConfigMysql.properties`
	- Setup Workload
		- End node ID: 120,000,001


### TPC-H
- In-house scripts based on the official TPC-H tools v3.0 + TPC-H-like benchmark with PostgreSQL (https://github.com/tvondra/pg_tpch.git) + more.

- Setup
	- Generate with scale factor 100
	- With DB indexes, postgres database goes beyond 200 GB.

	```shell
	$ ./init.sh nvme2n1 tpch beowulf
	$ ./tpch.sh nvme2n1 tpch beowulf
	```


### YCSB
- YCSB (https://github.com/brianfrankcooper/YCSB)

- Setup the benchmark
	```
	$ sudo apt install maven
	$ git checkout 0.17.0 # otherwise maven will compain
	```


## Obsolete benchmarks

### TPC-C on mysql
- Percorna Lab TPC-C (https://github.com/Percona-Lab/tpcc-mysql)

- Setup with 1200 warehouses (101 GB)
	```shell
	$ mysqladmin create tpcc1200
	$ mysql tpcc1200 < create_table.sql
	$ ./tpcc_load -h127.0.0.1 -d tpcc1200 -u root -P "mypassword" -w 1200
	$ mysql tpcc1200 < add_fkey_idx.sql
	```

### TPC-C on postgres
- Escada TPC-C (https://github.com/rmpvilaca/EscadaTPC-C)

- Setup
  - Build the benchmark
		```shell
		$ mvn package
		$ mvn assembly:assembly
		cd target/tpc-c-0.1-SNAPSHOT-tpc-c
		```

  - Edit etc/database-config.propergies
		```shell
		db.connection.string=jdbc:<postgresql://localhost/tpcc1200>
		db.driver=org.postgresql.driver
		db.user=userid
		db.password=mypassword
		```

  - Edit etc/workload-config.properties. The benchmark stops frequently with out of memory when clients > poolsize. Thus setup those values carefully.
	```shell
	tpcc.number.warehouses = 1200

	measurement.time = 20

	pool.size = 16
	clients = 16
	```

  - Create tables. Make sure that the tpcc1200 database and user are properly configured on the current postgresql instance.
	```shell
	$ psql -d tpcc1200 -f etc/sql/postgresql/createtable.sql
	```

  - Load the database
	```shell
	$ ./load.sh
	```

  - Create index and functions
	```shell
	$ psql -d tpcc1200 -f etc/sql/postgresql/createindex.sql
	$ for f in etc/sql/postgresql/*01; do psql -d tpcc1200 -f $f; done
	```

### RocksDB using db_bench

- RocksDB (https://github.com/facebook/rocksdb)

