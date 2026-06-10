pipeline {
    agent any

    environment {
        IMAGE_NAME = "aparnaapillai0coder/myapp:latest"
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Docker Info') {
            steps {
                sh '''
                docker version
                docker ps
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
            when {
                expression { false }
            }
            steps {
                sh '''
                kubectl apply -f deployment.yml
                kubectl apply -f service.yml
                kubectl rollout status deployment/mlops-app
                '''
            }
        }
        
        post {
            success {
                echo "MLOPS Pipeline SUCCESS"
            }
            failure {
                echo "Pipeline FAILED check logs"
            }
        }
    }
}