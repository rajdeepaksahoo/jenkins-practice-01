pipeline{
    agent any
    steps{
        step("Git-Pull"){
            echo "Pulling From Git..."
            checkout scm
        }

        step("Building"){
            echo "Building Spring Boot Project..."
            sh "./mvnw clean package -DskipTests"
        }

        step("Testing"){
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