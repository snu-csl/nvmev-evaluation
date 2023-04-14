# Script collection to help evaluation

- `eval_nvmev.sh`
  Top-level script to initiate the measurement

- `init_db.sh`
  Initialize a database instance from the original database

- `start_db.sh`
  Start a database instance considering CPU affinity

- `prep_db.sh`
  Call `init_db.sh` followed by `start_db.sh`

- `init_nvmev.sh`
  Initialize the NVMeVirt and related system configurations.

- `set_perf.py`, 
  Set the NVMeVirt's latency. `set_perf.py` calculates the inherent overhead in NVMeVirt to match to the target latency.

- `stat_cpu_utilization.sh`, `stat_io_utilization.sh`, `stat_io_depth.sh` `abort_eval.sh`
  Collect CPU utilization, IO utilization, and IO depth. Usually it does not require to use this script explicitly, however, should call `abort_eval.sh` in case you aborted an execution with ctrl-c.
