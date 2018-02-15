# An Apache Web App On A Local Kubernetes Cluster

The following instructions show how to install an Apache Web Server into a local Kubernetes
cluster. The web server is configured to communication with Apache Tomcat via 
the Apache mod_jk connector, to invoke a simple servlet.

This example application is based on the Docker Compose example found at https//github.com/Paritosh-Anand/Docker-Httpd-Tomcat. The application has been modified
to run under Kubernetes.

This application can be tested using the Kubernetes `minikube` tool which will create a local, single node Kubernetes cluster.

## Install Kubernetes

Both the `minikube` and `kubectl` commands are needed to run this example application.

The general instructions to install Kubernetes `minikube` can be found [here]( https://kubernetes.io/docs/tasks/tools/install-minikube/)

On MacOS, minikube can be installed with HomeBrew:

```bash
brew install minikube
```

Instructions to install `kubectl`` are [here](https://kubernetes.io/docs/tasks/tools/install-kubectl)

On MacOS, kubctl can be installed with HomeBrew:

```bash
brew install kubectl
```

## Create the Docker containers for the application

```bash
cd httpd
```
Edit the Docker file to include your own Docker hub repository name, or local repository, 
instead of `sbpcs59`. Next, run the build script to create the docker image. Using a local repository doesn't seem to work, so please contact me if this works for you.
```bash
./build.sh
```

Kubernetes defines environment variables in each container for network resources of 
other pods in a service. For example, `WEB_SERVICE_HOST` is defined as the IP address of The
Docker container running the `web` service (the httpd server). This variable is used in
the file `./tomcat/worker.properties`.

```bash
cd web 
```
Edit the Docker file to include your own Docker hub repository name, instead of `sbpcs59`. 

Next, run the build script to create the docker image.

```bash
./build.sh
```

## Start the local Kubernetes cluster

```bash
minikube start
```

Alternatively, if Docker for Mac is being used, `minikube` can be started with
```bash
minikube start --vm-driver=hyperkit
```

## Deploy the pods and services

First, modify each `*-deployment.yaml` file to include your Docker hub repo, instead
of `sbpcs59`, if desired.

Next, enter the commands to deploy the application into the cluster:

```bash
kubectl create -f httpd-claim0-persistentvolumeclaim.yaml
kubectl create -f web-deployment.yaml
kubectl create -f web-service.yaml
kubectl create -f httpd-deployment.yaml
kubectl create -f httpd-service.yaml
```

## Connect to the `httpd` services

First, get an external (in relation to the cluster) IP for the `httpd` service:

```bash
minikube service httpd --url
```

The IP address that is returned can be pasted into a web browser to access the Apache web server
application, for example:

```
http://192.168.99.101:30545/sample
```

## View the Kubernetes Cluster Dashboard

Resources of the local cluster can be viewed by starting a Kubernetes dashboard for the cluster:

```bash
minikube service --namespace kube-system kubernetes-dashboard
```

## Cleanup
If desired, the application can be stopped with the commands:

```bash
kubectl delete service web 
kubectl delete service httpd
kubectl delete deployment web
kubectl delete deployment httpd
```

Warning: the next command removes all persistent volumes on the local cluster:

```bash
kubectl delete pv --all
```

If deleting all volumes is not desired, then use `kubectl get pv` and delete the desired volumes with `delete pvc <volume-name>` for each volume to be deleted.

Next, the cluster can be stopped with:

```bash
minikube stop
```
