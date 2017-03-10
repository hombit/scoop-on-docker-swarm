#!/bin/bash

WORKER_HOSTNAMES=/scoop/worker_hostnames
SCOOP_HOSTFILE=/scoop/scoop_hostfile

# Wait workers start
sleep 10

# Find all workers addresses
dig +short tasks.scoop_root_worker >  $WORKER_HOSTNAMES
dig +short tasks.scoop_worker      >> $WORKER_HOSTNAMES

# Get number of CPUs on each host and produce SCOOP hostfile
WORKER_NUMBER=0
for H in $(cat $WORKER_HOSTNAMES); do
    CPUS=$(ssh -x -n -oStrictHostKeyChecking=no $H "grep -c ^processor /proc/cpuinfo")
    (( WORKER_NUMBER = WORKER_NUMBER + CPUS ))
    echo $H $CPUS >> $SCOOP_HOSTFILE
done

# Run our script and die
python3 -m scoop --hostfile $SCOOP_HOSTFILE -n $WORKER_NUMBER /script.py
