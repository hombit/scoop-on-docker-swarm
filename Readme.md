Docker swarm for Python SCOOP
=============================

The project shows how to run [SCOOP](http://scoop.readthedocs.io/) program with
[Docker swarm mode](https://docs.docker.com/engine/swarm/)

 

Architecture of the project
---------------------------

The project has only one Docker Swarm manager host and numerical Docker Swarm
worker hosts. Docker Swarm manager host runs two containers: `SCOOP` broker and
`SCOOP` root worker. Each Docker Swarm worker hosts run one `SCOOP` worker
container. `SCOOP` broker connects to each worker (including root worker) and
asks them to perform calculations. Root worker does one more thing: it runs
simple web-server (based on [bottle](http://bottlepy.org)) on port 8000 and show
the result of computation there.

### Diagrams

Architecture of the `SCOOP` project from [its
website](http://scoop.readthedocs.io/en/0.7/usage.html)

![](http://scoop.readthedocs.io/en/0.7/_images/architecture.png)

Architecture of the Docker Swarm from [Docker
website](https://docs.docker.com/engine/swarm/how-swarm-mode-works/nodes/)

![](https://docs.docker.com/engine/swarm/images/swarm-diagram.png)

Install Docker
--------------

You can install docker to each future docker swarm host manually or using
docker-machine

### Docker-machine way (preferred)

Install Docker onto your computer using instructions on
[docker.com](http://docker.com). Remember that you need all staff: Docker
Engine, Docker Machine and Docker Compose. Modern installation packages for
Windows and Mac include all of them.

 

You need ssh access to each of your hosts without password. Generate pair of
private and public ssh keys if you haven’t them yet (keep the default location):

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ssh-keygen -t rsa
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Copy them to each host. Here and further I use capitals to indicate words that
you should replace.

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ssh-copy-id USER@HOST_NAME
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Than install Docker on each host using `docker-machine` (in the terms of Docker
create Docker machine):

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
docker-machine create --driver generic --generic-ip-address=HOST_NAME --generic-ssh-key=/Users/hombit/.ssh/id_rsa --generic-ssh-user=USER DOCKER_MACHINE_NAME
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Now if you want to perform some `docker` or `docker-compose` command on
particular host you need to activate it and perform your command.

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Check status of the machine
docker-machine status DOCKER_MACHINE_NAME
# If it isn't running:
docker-machine start DOCKER_MACHINE_NAME
# Update environment
eval "$(docker-machine env DOCKER_MACHINE_NAME)"
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Now do what you need, you don’t need to ssh to your host.

### Manual way

Ssh to each your host and install Docker manually. Use instructions from
[docker.com](http://docker.com). When you need to perform some `docker` or
`docker-compose` command on the host, you should ssh to it.

Create swarm
------------

See [Docker swarm mode
tutorial](https://docs.docker.com/engine/swarm/swarm-tutorial/)

One of your Docker hosts will be a Leader. Ssh to this host or activate related
Docker machine. Than initialise swarm:

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
docker swarm --advertise-addr LEADER_IP_VISIBLE_FOR_SWARM_NODES
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Remember output and type it on every host that will be a member of the swarm:

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
docker swarm join --token TOKEN LEADER_IP_VISIBLE_FOR_SWARM_NODES:2377
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Return to the leader and check your swarm:

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
docker node ls
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

 

Generate ssh keys
-----------------

We need secret ssh keys to connect broker with workers. Generate pairs of ssh
keys for `SCOOP` broker (ssh client) and workers (ssh hosts):

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
yes | ssh-keygen -f secrets/ssh_client_rsa_key -N '' -C '' -t rsa
yes | ssh-keygen -f secrets/ssh_host_rsa_key -N '' -C '' -t rsa
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

 

Deploy Docker services
----------------------

Do on manager host:

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# In the future will be replaced with docker deploy
docker stack deploy --compose-file=docker-compose.yml scoop
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

`scoop` is the name of stack and it is hardcoded in the project, please don’t
change it.

Now you can check that all services have started:

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
docker stack ps scoop
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Check
-----

Go to http://YOUR_MANAGER_ADDRESS:8000 and check that it responds.
