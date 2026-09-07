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