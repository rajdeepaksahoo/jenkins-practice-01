pipeline {
    agent any

    stages {
        stage('Test') {
            steps {
                sh 'whoami'
                sh 'id'
                sh 'git --version'
                sh 'docker --version'
            }
        }
        stage("Git-Pull") {
            steps {
                echo "Pulling From Git..."
                checkout scm
            }
        }

        stage("Building") {
            steps {
                echo "Building Spring Boot Project..."
                sh "./mvnw clean package -DskipTests"
            }
        }

        stage("Testing") {
            steps {
                echo "Testing..."
                sh "./mvnw test"
            }
        }
        stage("Docker-Images-before") {
            steps {
                echo "Checking Docker Image"
                sh "docker images"
            }
        }
        stage("Docker-Build"){
            steps{
                echo "Building Docker Image"
                sh "docker build -t rajdeepak/jenkins-practice-01:latest ."
            }
        }

        stage("Push-Docker-Image"){
            steps{
                echo "Pushing Docker Image"
                sh "docker push  rajdeepak/jenkins-practice-01:latest"
            }
        }

        stage("Docker-Images-after") {
            steps {
                echo "Checking Docker Image"
                sh "docker images"
            }
        }
    }

    post {
        success {
            echo "Build Is Success."
        }

        failure {
            echo "Build Failure"
        }
    }
}