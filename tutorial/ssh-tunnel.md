# SSH Tunnel
  
## Docker Image
We will be using a slightly modified [docker-sshd].

### Create Modified Docker Image
    # see data/ssh-tunnel/Dockerfile
    $ docker build -t ssh-tunnel:1.0.3 data/ssh-tunnel
    $ docker tag ssh-tunnel:1.0.3 larioj/ssh-tunnel:1.0.3
    $ docker push larioj/ssh-tunnel:1.0.3

### Run Locally
    $ docker pull larioj/ssh-tunnel:1.0.3
    $ docker run \
        -p 2222:22 \
        -v $HOME/.ssh/id_rsa.pub:/etc/authorized_keys/larioj \
        -e SSH_USERS="larioj:888:888" docker.io/larioj/ssh-tunnel:1.0.3
    $ ssh $CARBON -p 2222
    $ docker ps
    $ docker stop $(docker ps -a -q)

## Run On Kubernetes

### Create a Secret
    $ kubectl create secret generic ssh-tunnel-authorized-keys \
        --from-file=${USER}=$HOME/.ssh/id_rsa.pub \
        --from-literal=SSH_USERS="${USER}:$(id -u):$(id -u)" \
        --dry-run -o yaml \
      | kubectl apply -f -

### Create a Deployment
    $ kubectl apply -f - <<EOF
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: ssh-tunnel
      labels:
        app: ssh-tunnel
    spec:
      replicas: 1
      selector:
        matchLabels:
          app: ssh-tunnel
      template:
        metadata:
          labels:
            app: ssh-tunnel
        spec:
          volumes:
          - name: ssh-tunnel-authorized-keys
            secret:
              secretName: ssh-tunnel-authorized-keys
          containers:
          - name: ssh-tunnel
            image: larioj/ssh-tunnel:1.0.3
            env:
            - name: SSH_USERS
              valueFrom:
                secretKeyRef:
                  name: ssh-tunnel-authorized-keys
                  key: SSH_USERS
            ports:
            - containerPort: 22
            volumeMounts:
            - mountPath: /etc/authorized_keys
              name: ssh-tunnel-authorized-keys
    EOF
    $ kubectl get deployment

### Create a Service
    $ kubectl apply -f - <<EOF
    apiVersion: v1
    kind: Service
    metadata:
      name: ssh-tunnel
      labels:
        app: ssh-tunnel
    spec:
      type: LoadBalancer
      ports:
      - port: 2222
        targetPort: 22
        protocol: TCP
      selector:
        app: ssh-tunnel
    EOF
    $ kubectl get service

## SSH into tunnel
    $ ssh larioj@35.247.0.51 -p 2222

## Debug
    $ kubectl get pod
    $ kubectl describe pod -l app=ssh-tunnel
    $ kubectl logs -l app=ssh-tunnel
    $ kubectl exec -it ssh-tunnel-674f59b4f4-rj77b  -- /bin/bash

[docker-sshd]: https://github.com/panubo/docker-sshd
