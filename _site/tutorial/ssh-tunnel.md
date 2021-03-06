# SSH Tunnel
    : vsplit
  
## Docker Image
https://github.com/panubo/docker-sshd

### Run Locally
    $ docker pull panubo/sshd:1.0.3
    $ docker run -d \
        -p 2222:22 \
        -v /secrets/id_rsa.pub:/root/.ssh/authorized_keys \
        -v /mnt/data/:/data/ \
        -e SSH_ENABLE_ROOT=true \
        docker.io/panubo/sshd:1.0.3
    $ docker run \
        -p 2222:22 \
        -v $HOME/.ssh/id_rsa.pub:/etc/authorized_keys/larioj \
        -e SSH_USERS="larioj:888:888" docker.io/panubo/sshd:1.0.3
    $ ssh localhost -p 2222
    $ docker ps
    $ docker stop $(docker ps -a -q)

## Run On Kubernetes
    $ cat <<EOF
      name: ""
        bar: foo
      foo: "teuha"
      EOF

## Local ssh
    $ /usr/local/Cellar/nmap/7.70/bin/nmap -sP 10.0.0.168/24
    $ ssh $CARBON
