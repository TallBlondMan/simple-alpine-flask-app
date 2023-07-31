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
                // Build Docker image for your web app
                script {
                    def imageName = 'my-flask-app'
                    def imageTag = 'your-app-image-tag'
                    
                    docker.build(imageName + ':' + imageTag, '-f Dockerfile .')
                }

                // Push Docker image to Docker host
                script {
                    def imageName = 'my-flask-app'
                    def imageTag = '$env.BUILD_NUMBER'
                    def dockerHost = 'your-docker-host' // Replace with your Docker host IP/hostname

                    docker.withRegistry("https://${dockerHost}") {
                        dockerImage.push(imageName + ':' + imageTag)
                    }
                }

                // SSH into Docker host and run the container
                script {
                    def dockerHost = 'your-docker-host' // Replace with your Docker host IP/hostname
                    def imageName = 'your-app-image-name'
                    def imageTag = 'your-app-image-tag'
                    def containerName = 'your-container-name'

                    sh "ssh user@${dockerHost} 'docker pull ${imageName}:${imageTag}'"
                    sh "ssh user@${dockerHost} 'docker run -d --name ${containerName} -p 80:5000 ${imageName}:${imageTag}'"
            }
        }
    }
}
