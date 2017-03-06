#!/bin/bash

yes | sudo ssh-keygen -f /etc/ssh/ssh_host_rsa_key -N '' -t rsa
yes | sudo ssh-keygen -f /etc/ssh/ssh_host_dsa_key -N '' -t dsa
yes | sudo ssh-keygen -f /etc/ssh/ssh_host_ecdsa_key -N '' -t ecdsa
yes | sudo ssh-keygen -f /etc/ssh/ssh_host_ed25519_key -N '' -t ed25519

sudo /etc/init.d/ssh start
sleep infinity
