pipeline {
    agent {
        docker {
            image 'docker:latest'
            args '-v /var/run/docker.sock:/var/run/docker.sock'
            }
        }

    environment {
        VENV_DIR = 'venv'
        GCP_PROJECT = 'storage-cc-data'
        GCLOUD_PATH = "/var/jenkins_home/google-cloud-sdk/bin"
        KUBERCTL_AUTH_PLUGIN = "/usr/lib/google-cloud.sdk"
    }

    stages{

        stage("Cloning from Github.."){
            steps{
                script{
                    echo 'Cloning from Github..'
                    checkout scmGit(branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[credentialsId: 'github-token-id-1', url: 'https://github.com/aparnaapillai0-coder/Machine_Learning_MLOPS_Project.git']])
                }
            }
        }

        stage("Creating a Virtual Environment...."){
            steps{
                script{
                    echo 'Creating a Virtual Environment....'
                    sh '''
                    python3 -m venv ${VENV_DIR}
                    . ${VENV_DIR}/bin/activate
                    python3 -m pip install --upgrade pip
                    pip install -e .
                    pip install dvc
                    '''
                }
            }
        }

        stage('DVC Pull'){
            steps{
                withCredentials([file(credentialsId:'gcp-key', variable:'GOOGLE_APPLICATION_CREDENTIALS')]){
                    script{
                        echo 'DVC pull....'
                        sh '''
                        . ${VENV_DIR}/bin/activate
                        dvc pull
                        '''
                    }
                }
            }
        }


        stage('Build Docker Image'){
            steps{
                script{
                    echo 'Building Docker Image...'
                    sh '''
                    docker build -t mlops-app:latest .
                    '''
                }
            }
        }

        stage('Deploy to Minikube'){
            steps{
                script{
                    echo 'Deploying to Minikube...'
                    sh '''
                    kubectl apply -f deployment.yml
                    '''
                }
            }
        }
    }
}
