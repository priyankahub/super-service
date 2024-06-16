pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                script {
                    sh 'dotnet build src/SuperService.csproj'
                }
            }
        }
        stage('Test') {
            steps {
                script {
                    sh 'dotnet test test/SuperService.UnitTests/SuperService.UnitTests.csproj'
                }
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    sh 'docker build -t superservice:latest .'
                }
            }
        }
        stage('Deploy') {
            steps {
                script {
                    sh 'docker-compose up -d'
                }
            }
        }
    }
}
