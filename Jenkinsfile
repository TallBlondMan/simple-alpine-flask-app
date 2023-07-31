pipeline {
    agent { 
        node {
            label 'docker-alpine-python-flask'
            }
    }
    triggers {
        pollSCM 'H/5 * * * *'
    }
    stages {
        stage('Build') {
            steps {
                echo "Building.."
                sh 'pip install -r requirements.txt'
                sh 'flask --app app.py run --host=0.0.0.0 --port=8080 &'
                echo "Server should be up and running"
            }
        }
        stage('Test') {
            steps {
                echo "Testing.."
                sh 'apk add curl'
                sh 'curl localhost:8080'
                echo "Testing done"
            }
        }
        stage('Deliver') {
            steps {
                echo "Starting delivery"
                script {
                    def imageName = "my-flask-app"
                    def imageTag = "${env.BUILD_NUMBER}"
                    def dockerHost = '10.6.0.232'
                    
                    docker.withServer("ssh://jenkins@${dockerHost}") {
                        docker.build(imageName + ':' + imageTag, '-f Dockerfile .')
                    }
                }

                // Push Docker image to Docker host
                script {
                    def imageName = 'my-flask-app'
                    def imageTag = "${env.BUILD_NUMBER}"
                    def dockerHost = '10.6.0.232'

                    docker.withServer("ssh://jenkins@${dockerHost}") {
                        dockerImage.push(imageName + ':' + imageTag)
                    }
                }

                // SSH into Docker host and run the container
                script {
                    def dockerHost = '10.6.0.232' // Replace with your Docker host IP/hostname
                    def imageName = 'my-flask-app'
                    def imageTag = "${env.BUILD_NUMBER}"
                    def containerName = "flask-ver-${env.BUILD_NUMBER}"

                    sh "ssh jenkins@${dockerHost} 'docker pull ${imageName}:${imageTag}'"
                    sh "ssh jenkins@${dockerHost} 'docker run -d --name ${containerName} -p 8080:8080 ${imageName}:${imageTag}'"
                }
                echo "Server should be up and running..."
            }
        }
    }
}