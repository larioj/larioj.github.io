# SSH Tunnel on App Engine

## Create Configuration
    $ mkdir -p data/ssh-tunnel-on-app-engine/
    $ touch data/ssh-tunnel-on-app-engine/app.yaml

## Create the Dockerfile
    $ touch data/ssh-tunnel-on-app-engine/Dockerfile
    $ mkdir -p data/ssh-tunnel-on-app-engine/authorized_keys
    $ cp $HOME/.ssh/id_rsa.pub \
        data/ssh-tunnel-on-app-engine/authorized_keys/larioj

## Launch App
    $ gcloud app create --region=us-west2
    $ cd data/ssh-tunnel-on-app-engine/ && gcloud app deploy
    $ gcloud app describe
    $ gcloud compute instances list
    $ gcloud app delete
    
