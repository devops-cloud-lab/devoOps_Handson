pipeline {
    agent { label 'ci-agent' }
    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/<rdev80505@gmail.com>devoOps_Handson.git'
            }
        }
        stage('Build Docker Image') {
            steps {
                sh 'docker build -t prt-cicd-app .'
            }
        }
        stage('Run Container') {
            steps {
                sh 'docker run -d -p 8080:80 prt-cicd-app'
            }
        }
    }
}
