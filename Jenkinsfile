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

        stage('Build Docker') {
            steps {
                sh 'docker build -t $IMAGE_NAME .'
            }
        }

        stage('Deploy') {
            steps {
                sh '''
                kubectl apply -f deployment.yml
                kubectl apply -f service.yml
                '''
            }
        }
    }
}