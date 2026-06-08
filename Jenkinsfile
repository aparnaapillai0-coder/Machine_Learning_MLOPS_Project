pipeline {
    agent any

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
                    checkout scmGit(branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[credentialsId: 'github-token-id-1', url: 'https://github.com/abhichris63/MLOPS_project.git']])
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


        stage('Building and Pushing Image to GCP'){
            steps{
                withCredentials([file(credentialsId:'gcp-key', variable:'GOOGLE_APPLICATION_CREDENTIALS')]){
                    script{
                        echo 'Building and Pushing Image to GCP...'
                        sh '''
                        export PATH=$PATH:${GCLOUD_PATH}
                        gcloud auth activate-service-account --key-file=${GOOGLE_APPLICATION_CREDENTIALS}
                        gcloud config set project ${GCP_PROJECT}
                        gcloud auth configure-docker --quiet
                        docker build -t gcr.io/${GCP_PROJECT}/ml-project:latest .
                        docker push gcr.io/${GCP_PROJECT}/ml-project:latest
                        '''
                    }
                }
            }
        }

        stage('Deployment to Kubernates'){
            steps{
                withCredentials([file(credentialsId:'gcp-key', variable:'GOOGLE_APPLICATION_CREDENTIALS')]){
                    script{
                        echo 'Deployment to Kubernates...'
                        sh '''
                        export PATH=$PATH:${GCLOUD_PATH}:${KUBERCTL_AUTH_PLUGIN}
                        gcloud auth activate-service-account --key-file=${GOOGLE_APPLICATION_CREDENTIALS}
                        gcloud config set project ${GCP_PROJECT}
                        gcloud container clusters get-credentials ml-app-cluster --region us-central1
                        kubect1 apply -f deployment.yaml
                        '''
                    }
                }
            }
        }

    }
}