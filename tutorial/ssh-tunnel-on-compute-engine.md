# SSH Tunnel of Google Compute Engine

## Create VM
    $ gcloud compute machine-types list
    $ gcloud compute instances create default --machine-type=f1-micro

## Delete VM
    $ gcloud compute instances delete default

## Configure SSH
    $ gcloud compute config-ssh
    $ ssh default.us-west1-b.larioj

## Copy Keys to Host
    $ scp $HOME/.ssh/google_compute_known_hosts \
        $CARBON:.ssh/google_compute_known_hosts
    $ scp $HOME/.ssh/config $CARBON:.ssh/config
    $ scp $HOME/.ssh/google_compute_engine.pub \
        $CARBON:.ssh/google_compute_engine.pub
    $ scp $HOME/.ssh/google_compute_engine \
        $CARBON:.ssh/google_compute_engine
    # update .ssh/config in carbon to point to correct home dir
    $ ssh $CARBON

## Setup Tunnel On Carbon
    $ ssh $CARBON
    # on Carbon
    $ autossh -N -i .ssh/google_compute_engine default.us-west1-b.larioj \
        -R 2222:localhost:22 \
        -R 3049:localhost:2049 \
        -R 2375:localhost:2375


## Forward Remote Ports to Local Ports
    $ autossh -M 0 -N default.us-west1-b.larioj \
        -L 2222:localhost:2222 \
        -L 3049:localhost:3049 \
        -L 2375:localhost:2375

## SSH Through Tunnel
    $ ssh localhost -p 2222

## Docker
    $ docker pull debian

## Mount NFS
    $ sudo mount -t nfs -o resvport,rw,port=3049 localhost:/mnt/data /mnt/data
