#!/bin/bash

# Set broker's ssh public key as known
cp -vf /run/secrets/ssh_client_rsa_key.pub /scoop/.ssh/authorized_keys

sudo /etc/init.d/ssh start

sleep infinity
