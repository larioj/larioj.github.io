# Setup NFS

## Install on Ubuntu
    $ sudo apt update
    $ sudo apt install nfs-kernel-server
    $ sudo chown nobody:nogroup /mnt/data
    $ sudo chmod 777 /mnt/data
    $ sudo echo '/mnt/data 10.0.0.168(rw,sync,no_subtree_check)' \
        >> /etc/exports
    $ sudo exportfs -a
    $ sudo systemctl restart nfs-kernel-server
    $ sudo ufw status

## Setup Client (Mac)
    $ sudo mount -t nfs -o resvport,rw $CARBON:/mnt/data /mnt/data

## Fid UID and GID On Mac
    $ id -u
    $ id -g

## Change Ubuntu User Id
    $ sudo usermod -u 501 larioj
    $ sudo groupmod -g 20 larioj
