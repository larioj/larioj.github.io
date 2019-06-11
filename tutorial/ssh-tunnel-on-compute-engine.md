# SSH Tunnel of Google Compute Engine

## Create VM
    $ gcloud compute machine-types list
    $ gcloud compute instances create default --machine-type=f1-micro

## Configure SSH
    $ gcloud compute config-ssh
    $ ssh default.us-west1-b.larioj

## Delete VM
    $ gcloud compute instances delete default
