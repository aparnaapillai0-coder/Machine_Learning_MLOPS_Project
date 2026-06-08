Pipeline {
    agent {
        label 'docker-enabled'
    }
    
    environment {
        VENV_DIR = 'venv'
    }
    
    stages {
        stage("Checkout Code") {
            steps {
                checkout scm
            }
        }
        
        stage("Create Virtual Environment") {
            steps {
                sh '''
                python3 -m venv ${VENV_DIR}
                . ${VENV_DIR}/bin/activate
                pip install --upgrade pip
                pip install -e .
                pip install dvc
                '''
            }
        }
        
        stage("DVC Pull") {
            steps {
                withCredentials([file(credentialsId:'gcp-key', variable:'GOOGLE_APPLICATION_CREDENTIALS')]) {
                    sh '''
                    . ${VENV_DIR}/bin/activate
                    dvc pull
                    '''
                }
            }
        }
        
        stage("Build Docker Image") {
            steps {
                sh '''
                docker version
                docker build -t mlops-app:latest .
                '''
            }
        }
        
        stage("Deploy to Minikube") {
            steps {
                sh '''
                kubectl version --client
                kubectl apply -f deployment.yml
                '''
            }
        }
    }
}