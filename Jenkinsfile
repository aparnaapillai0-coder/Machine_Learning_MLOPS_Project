pipeline {
    agent any

    environment {
        IMAGE_NAME = "myrepo/myapp:latest"
    }

    stages {

        stage('Checkout Code') {
            steps {
                echo 'Code checkout completed'
                checkout scm
            }
        }

        stage('Create Virtual Environment & Install Dependencies') {
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
                sh '''
                docker login -u $DOCKER_USER -p $DOCKER_PASS
                docker push $IMAGE_NAME
                '''
            }
        }

        stage('Deploy') {
            steps {
                sh '''
                docker stop myapp || true
                docker rm myapp || true

                docker pull $IMAGE_NAME

                docker run -d \
                    --name myapp \
                    -p 80:8080 \
                    $IMAGE_NAME
                '''
            }
        }
    }

    post {
        success {
            echo 'Pipeline executed successfully'
        }
        failure {
            echo 'Pipeline failed Check logs'
        }
    }
}