#!/usr/bin/env python3
import sys
import os

minimum_latency = [ 6610, 9870 ] # Minimum nanoseconds for read and write
#minimum_latency = [ 0, 0 ] # Minimum nanoseconds for read and write

if len(sys.argv) == 2 and sys.argv[1] == "max":
    delay_initial = [1, 1]
    per_op_latency = [1, 1]
    io_unit_shift = 15
else:
    if len(sys.argv) < 4:
        print("Usage: %s [Read latency (us)] [Write latency (us)] [Read target bandwidth (MB/s)] {Write target bandwidth (MB/s)}" % (sys.argv[0]))
        sys.exit(1)

    target_latency = [ float(sys.argv[1]), float(sys.argv[2]) ]
    target_bw = [ float(sys.argv[3]), float(sys.argv[3]) ]
    if len(sys.argv) == 5:
        target_bw[1] = float(sys.argv[4])


    io_unit_shift = 12
    io_unit_size = 1 << (io_unit_shift - 10)

    # The number of operations per second = bandwidth / per-operation size
    nr_ops = [ bw * 1024 / io_unit_size for bw in target_bw ]

    # Per-operation latency = 1 / # of ops
    per_op_latency = [ 1 / ops * 1000000000 for ops in nr_ops]

    delay_initial = [ max(target * 1000 - per_op - m, 1) for (target, per_op, m) in zip(target_latency, per_op_latency, minimum_latency) ]

os.system("sudo sh -c \"echo %d %d %d > /proc/nvmev/read_times\"" % (delay_initial[0], per_op_latency[0], 0))
os.system("sudo sh -c \"echo %d %d %d > /proc/nvmev/write_times\"" % (delay_initial[1], per_op_latency[1], 0))
os.system("sudo sh -c \"echo %d %d > /proc/nvmev/io_units\"" % (1, io_unit_shift))
