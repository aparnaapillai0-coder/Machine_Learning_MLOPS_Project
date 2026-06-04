pipeline{
    agent any
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
}