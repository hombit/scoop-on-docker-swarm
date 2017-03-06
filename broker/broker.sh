#!/bin/bash

# Wait workers start
sleep 10

# Find all workers addresses
dig +short tasks.scoop_root_worker >  /scoop/worker_hostnames
dig +short tasks.scoop_worker      >> /scoop/worker_hostnames
# Number of workers
WORKERS_NUMBER=$(wc /scoop/worker_hostnames | awk '{print $1;}')

# Run our script and die
python3 -m scoop --hostfile /scoop/worker_hostnames -n ${WORKERS_NUMBER} /script.py
