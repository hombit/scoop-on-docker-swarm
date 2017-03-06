FROM scoop_base

# Temporary switch back to root to perform RUN
USER root

# Install ssh server, delete all automatically generated keys and link RSA keys to docker's secret location
RUN apt-get update &&\
    apt-get install -y openssh-server &&\
    rm -vf /etc/ssh/ssh_host*_key* &&\
    ln -sv /run/secrets/ssh_host_rsa_key /etc/ssh/ssh_host_rsa_key &&\
    ln -sv /run/secrets/ssh_host_rsa_key.pub /etc/ssh/ssh_host_rsa_key.pub &&\
    sed -i -e 's|^\(HostKey /etc/ssh/ssh_host_[^r][^_]\+_key\)$|# \1|' /etc/ssh/sshd_config &&\
    apt-get autoremove -y &&\
    apt-get clean -y &&\
    rm -rvf /var/lib/apt/lists/* &&\
    truncate -s 0 /var/log/*log

# Container exposes ssh port 22 to the outer world
EXPOSE 22

# Perform all commands from scoop's name
USER scoop

COPY worker.sh /worker.sh

CMD ["/bin/bash", "/worker.sh"]
