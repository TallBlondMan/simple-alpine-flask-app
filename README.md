# Simple Alpine Docker Flask Application

This project was made to test and showcase Jenkins skills.
Project was tested on a dockerized version of Jenkins which pose some issues with docker deployment but that will be described later.


## How to setup

1. To run this project you need a Jenkins with Docker container.
   I made one here - https://github.com/TallBlondMan/jenkins-with-docker
2. This project deploys final image on a remote server with docker installed.
   > ### Special config is required 
   >
   > You need to modify the docker.service to listen on port 2376: 
   >    /lib/systemd/system/docker.service
   >    ExecStart=/usr/bin/dockerd -H fd:// -H tcp://0.0.0.0:2376 --containerd=/run/containerd/containerd.sock
   >
   > And make sure that the port isn't blocked
3. 