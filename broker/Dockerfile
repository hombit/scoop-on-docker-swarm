FROM scoop_base

# Temporary switch back to root to perform RUN
USER root

# Install ssh client and link RSA keys to docker's secret location. Also install dig for DNS lookup
RUN apt-get update &&\
    apt-get install -y openssh-client dnsutils &&\
    ln -sv /run/secrets/ssh_client_rsa_key /scoop/.ssh/id_rsa &&\
    ln -sv /run/secrets/ssh_client_rsa_key.pub /scoop/.ssh/id_rsa.pub &&\
    apt-get autoremove -y &&\
    apt-get clean -y &&\
    rm -rvf /var/lib/apt/lists/* &&\
    truncate -s 0 /var/log/*log

# Expose web port
EXPOSE 8000

# Perform all commands from scoop's name
USER scoop

COPY broker.sh /broker.sh

CMD ["/bin/bash", "/broker.sh"]
