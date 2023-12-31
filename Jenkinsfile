pipeline {
    agent none  
    // Trigers the build every 5 min if there are changes in repo
    triggers {
        pollSCM 'H/5 * * * *'
    }
    stages {
        // This will build the image on 'worker' and run it for tests
        stage('Build and Test') {
            agent {
                label 'docker-alpine-python-flask'
            }
            steps {
                    echo "=============Building=================="
                    sh 'pip install -r requirements.txt'
                    sh 'flask --app app.py run --host=0.0.0.0 --port=8080 &'
                    echo "Server should be up and running"

                    // Combinig stages so that they are made on the same node
                    echo "==============Testing==================="
                    sh 'apk add curl'
                    sh 'curl localhost:8080'
                    echo "Testing done"
                    // Cleanup of running Agent - it fails to remove it after stage end???
                    sh "docker ps -a | grep alpine-python-flask | awk '{print \$1}' | xargs -r docker rm -f"
            }
        }
        stage('Deliver') {
            steps {
                // This will build image, push image to repo and run the app on remote server with newest image
                echo "===========Starting delivery============"
                // Build Docker image
                node ('Deployment') {
                    script{
                        def imageName = "tallblondman/my-flask-app"
                        def imageTag = "${env.BUILD_NUMBER}"
                        def dockerHost = '10.6.0.232:2376'
                        sh 'ls -l'
                        sh 'pwd'
                        node {
                            checkout scm
                            docker.withServer("tcp://${dockerHost}") {
                                docker.build(imageName + ':' + imageTag, '-f Dockerfile .')
                            }
                        }
                    }
                // Push Docker image to Docker host 
                /*
                    script {
                        
                        def imageName = 'my-flask-app'
                        def imageTag = "${env.BUILD_NUMBER}"
                        def dockerHost = '10.6.0.232:2376'

                            node {
                                checkout scm
                                docker.withServer("tcp://${dockerHost}") {
                                    dockerImage.push(imageName + ':' + imageTag)
                                }
                            }
                        }
                */        

                    // SSH into Docker host and run the container
                    script {
                        def imageName = "tallblondman/my-flask-app"
                        def imageTag = "${env.BUILD_NUMBER}"
                        def containerName = "flask-ver-${env.BUILD_NUMBER}"

                        sh 'hostname'
                        sh 'pwd'
                        sh "docker ps -a | grep flask-ver | awk '{print \$1}' | xargs -r docker rm -f"
                        sh "docker run -d --name ${containerName} -p 8080:8080 ${imageName}:${imageTag}"
                    }
                    echo "Server should be up and running..."
                }
            }
        }
    }
}