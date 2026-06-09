pipeline {
    agent any
    
    stages {

        stage('Checkout Code') {
            steps {
                echo 'Code checked out successfully'
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
                sh '''
                    . venv/bin/activate
                    pip install dvc
                    dvc pull || true
                '''
            }
        }
        
        stage('Build Docker Image') {
            steps {
                sh '''
                    docker build -t mlops-app .
                '''
            }
        }

    }
}