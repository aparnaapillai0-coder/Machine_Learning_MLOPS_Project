pipeline {
    agent any

    environment {
        VENV_DIR = 'venv'
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
    }

     stages{
        stage("Creating a Virtual Environment...."){
            steps{
                script{
                    echo 'Creating a Virtual Environment....'
                    sh '''
                    python -m venv ${VENV_DIR}
                    . ${VENV_DIR}/bin/activate
                    pip install --upgrade pip
                    pip install -e .
                    pip install dvc
                    '''
                }
            }
        }     
     }
     

        stages{
            stage('DVC Pull'){
            steps{
                withCredentials([file(credentialsId:'gcp-key', variable:'GOGLE_APPLICATION_CREDENTIALS')]){
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
    }
}