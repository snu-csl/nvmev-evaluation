#!/bin/bash

echo -n "Drop page cache..."
sync
sudo sh -c "echo 3 > /proc/sys/vm/drop_caches"
echo " "
