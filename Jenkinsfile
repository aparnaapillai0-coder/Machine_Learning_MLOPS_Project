pipeline {
    agent any

    stages {

        stage('Checkout Code') {
            steps {
                git url: 'https://github.com/aparnaapillai0-coder/Machine_Learning_MLOPS_Project', branch: 'main'
            }
        }

        stage('Create Virtual Environment') {
            steps {
                sh '''
                    python3 -m venv venv
                    . venv/bin/activate
                    pip install -r requirements.txt
                '''
            }
        }

        stage('DVC Pull') {
            steps {
                sh 'dvc pull || echo "DVC not configured"'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t mlops-app .'
            }
        }

        stage('Deploy to Minikube') {
            steps {
                sh 'echo "Deployment step placeholder"'
            }
        }

    }
}