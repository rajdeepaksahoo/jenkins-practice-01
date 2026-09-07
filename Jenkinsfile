pipeline{
    agent any
    stages{
        stage("Git-Pull"){
            echo "Pulling From Git..."
            checkout scm
        }

        stage("Building"){
            echo "Building Spring Boot Project..."
            sh "./mvnw clean package -DskipTests"
        }

        stage("Testing"){
            echo "Testing..."
            sh "./mvnw test"
        }
    }

    post{
        success{
            echo "Build Is Success."
        }
        failure{
            echo "Build Failure"
        }
    }
}