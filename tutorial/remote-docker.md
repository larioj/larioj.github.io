# Attach Local Client To Remote Docker
This instructions are for attaching a mac client to a
docker daemon running on ubuntu. This requires docker
version 18 and above. Note that `$CARBON` is the machine
running ubuntu.

## Install Docker On Host
We follow the instructions at [docker][1] to install on ubuntu.

    $ ssh $CARBON
    $ sudo apt-get remove \
        docker docker-engine docker.io containerd runc
    $ sudo apt-get update
    $ sudo apt-get install \
        apt-transport-https \
        ca-certificates \
        curl \
        gnupg-agent \
        software-properties-common
    $ curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
        | sudo apt-key add -
    $ sudo apt-key fingerprint 0EBFCD88
    $ sudo add-apt-repository \
       "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
       $(lsb_release -cs) \
       stable"
    $ sudo apt-get update
    $ sudo apt-get install docker-ce docker-ce-cli containerd.io

## Set Up Docker in Host
Based on this [blog post][2].

    
    # These commands get run inside of your host
    $ ssh $CARBON
    
    # Create the directory to store the configuration file.
    $ sudo mkdir -p /etc/systemd/system/docker.service.d
    
    # Create a new file to store the daemon options.
    $ sudo nano /etc/systemd/system/docker.service.d/options.conf
    
    # Now make it look like this and save the file when you're done:
    [Service]
    ExecStart=
    ExecStart=/usr/bin/dockerd -H unix:// -H tcp://0.0.0.0:2375
    
    # Reload the systemd daemon.
    $ sudo systemctl daemon-reload
    
    # Restart Docker.
    $ sudo systemctl restart docker

## Install Client
Based on [stackoverflow][3]. We can just download the binaries
for mac [here][4]. Now we just need to extract and copy the
client somewhere in our path.

    $ cp ~/Downloads/docker/docker /usr/local/personal/bin/docker
    $ which docker

## Configure client
Add `export DOCKER_HOST=tcp://X.X.X.X:2375` to $HOME/.profile

    $ echo $DOCKER_HOST

## Test Client

    $ docker --version
    $ docker run hello-world
    $ docker pull ubuntu
    $ docker run -it ubuntu /bin/bash

## Caveats
Anyone with access to port 2375 can run commands on docker. This
is dangerous. I'll try to figure out how to restrict access, but
this works for me for now.

[1]: https://docs.docker.com/install/linux/docker-ce/ubuntu/
[2]: https://nickjanetakis.com/blog/docker-tip-73-connecting-to-a-remote-docker-daemon
[3]: https://stackoverflow.com/questions/38675925/is-it-possible-to-install-only-the-docker-cli-and-not-the-daemon
[4]: https://download.docker.com/mac/static/stable/x86_64/
