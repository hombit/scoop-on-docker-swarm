FROM python:3.6

# Install SCOOP. Also install simple web-server bottle
RUN pip install scoop bottle &&\
    rm -rvf /root/.cache

# Install sudo and allow non-password login
RUN apt-get update &&\
    apt-get install -y sudo &&\
    sed -i -e 's/^%sudo.\+$/%sudo\tALL=(ALL)NOPASSWD:ALL/' /etc/sudoers &&\
    apt-get autoremove -y &&\
    apt-get clean -y &&\
    rm -rvf /var/lib/apt/lists/* &&\
    truncate -s 0 /var/log/*log

# Create user scoop with $HOME at /scoop and ask docker to perform commands from her name
RUN useradd -r -m -d /scoop -s /bin/bash -g sudo scoop
USER scoop

# Create directory for ssh keys
RUN mkdir -p /scoop/.ssh

# Copy our SCOOP python script
COPY script.py /script.py

# Do nothing and die after start
CMD ["bash", "-c", ""]
