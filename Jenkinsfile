pipeline {
    agent any

    stages {

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

        stage("Docker-Build"){
            steps{
                echo "Building Docker Image"
                sh "docker build -t jenkins-practice-01:latest ."
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