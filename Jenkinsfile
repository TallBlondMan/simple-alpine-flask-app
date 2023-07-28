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
                echo 'Deliver....'
                echo "doing delivery stuff.."
            }
        }
    }
}
