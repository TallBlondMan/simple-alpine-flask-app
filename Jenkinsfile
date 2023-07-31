pipeline {
    agent { 
        // Chose the node to use - this example it's Docker Cloud template
        node {
            label 'docker-alpine-python-flask'
            }
    }
    // Trigers the build every 5 min if there are changes in repo
    triggers {
        pollSCM 'H/5 * * * *'
    }
    stages {
        // This will build the image on 'worker' and run it for tests
        stage('Build') {
            steps {
                echo "Building.."
                sh 'pip install -r requirements.txt'
                sh 'flask --app app.py run --host=0.0.0.0 --port=8080 &'
                echo "Server should be up and running"
            }
        }
        stage('Test') {
            // Some complex testing stage - other workers can be used to test the app
            // this is simple curl
            steps {
                echo "Testing.."
                sh 'apk add curl'
                sh 'curl localhost:8080'
                echo "Testing done"
            }
        }
        stage('Deliver') {
            steps {
                // This will build image, push image to repo and run the app on remote server with newest image
                echo "Starting delivery"

                // Build Docker image
                script {
                    def imageName = "my-flask-app"
                    def imageTag = "${env.BUILD_NUMBER}"
                    def dockerHost = '10.6.0.232:2376'
                    node {
                        docker.withServer("tcp://${dockerHost}") {
                            docker.build(imageName + ':' + imageTag, '-f Dockerfile .')
                        }
                    }
                }

                // Push Docker image to Docker host
                script {
                    def imageName = 'my-flask-app'
                    def imageTag = "${env.BUILD_NUMBER}"
                    def dockerHost = '10.6.0.232:2376'

                    node {
                        docker.withServer("tcp://${dockerHost}") {
                            dockerImage.push(imageName + ':' + imageTag)
                        }
                    }
                }

                // SSH into Docker host and run the container
                script {
                    def dockerHost = '10.6.0.232' 
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