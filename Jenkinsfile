pipeline {
    agent any

    environment {
        IMAGE_NAME = "myrepo/myapp:latest"
    }

    stages {

        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }

        stage('Debug Docker') {
            steps {
                sh '''
                docker info
                docker ps
                '''
            }
        }

        stage('Setup Environment') {
            steps {
                sh '''
                python3 -m venv venv
                venv/bin/pip install --upgrade pip
                venv/bin/pip install -r requirements.txt
                '''
            }
        }

        stage('DVC Pull') {
            steps {
                sh '''
                venv/bin/pip install dvc
                venv/bin/dvc pull || true
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                docker build -t $IMAGE_NAME .
                '''
            }
        }

        stage('Push Docker Image') {
             steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-creds',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh '''
                    echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                    docker push $IMAGE_NAME
                     '''
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh '''
                kubectl apply -f deployment.yml
                kubectl apply -f service.yml

                kubectl rollout status deployment/mlops-app
                '''
            }
        }
    }

    post {
        success {
            echo 'Deployment to Kubernetes successful'
        }
        failure {
            echo 'Pipeline failed Check logs'
        }
    }
}