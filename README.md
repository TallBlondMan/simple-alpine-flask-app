# Simple Alpine Docker Flask Application

This project was made to test and showcase Jenkins skills.
Project was tested on a dockerized version of Jenkins which pose some issues with docker deployment but that will be described later.


## How to setup

1. To run this project you need a Jenkins with Docker container.
   I made one here - https://github.com/TallBlondMan/jenkins-with-docker
2. This project deploys final image on a remote server with docker and java installed.

 ### Special config is required 
   >
   > You need to modify the docker.service to listen on port 2376. 
   >
   >    `/lib/systemd/system/docker.service`
   >
   >    `ExecStart=/usr/bin/dockerd -H fd:// -H tcp://0.0.0.0:2376 --containerd=/run/containerd/containerd.sock`
   >
   > And make sure that the port isn't blocked

3. You will also need a Socat container on your host running Jenkins-docker will allow to use Cloud Docker provider in Jenkins.
   More info - https://stackoverflow.com/questions/47709208/how-to-find-docker-host-uri-to-be-used-in-jenkins-docker-plugin 

   Run the container with params
   `docker run -d --restart=always -p 127.0.0.1:2376:2375 --network jenkins -v /var/run/docker.sock:/var/run/docker.sock alpine/socat tcp-listen:2375,fork,reuseaddr unix-connect:/var/run/docker.sock`

4. Run the Jenkins container with default config found on git page

## Running the project

Just create a new pipeline and configure it to use Git URL.
Get script from SCM and the rest should go through.
