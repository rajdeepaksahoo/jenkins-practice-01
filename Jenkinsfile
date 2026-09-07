pipeline {
    agent any

    stages {

        stage('Environment') {
            steps {
                sh 'whoami'
                sh 'id'
                sh 'git --version'
                sh 'docker --version'
            }
        }

        stage('Git-Pull') {
            steps {
                echo 'Pulling From Git...'
                checkout scm
            }
        }

        stage('Build') {
            steps {
                echo 'Building Spring Boot Project...'
                sh './mvnw clean package -DskipTests'
            }
        }

        stage('Test') {
            steps {
                echo 'Testing...'
                sh './mvnw test'
            }
        }

        stage('Docker-Build') {
            steps {
                echo 'Building Docker Image...'
                sh '''
                    docker build \
                        -t razdeepak/jenkins-practice-01:latest \
                        .
                '''
            }
        }

        stage('Docker-Push') {
            steps {
                echo 'Pushing Docker Image...'
                sh '''
                    docker push \
                        razdeepak/jenkins-practice-01:latest
                '''
            }
        }

        stage('Docker-Run') {
            steps {
                echo 'Running Docker Image...'

                sh '''
                    docker stop jenkins-practice 2>/dev/null || true
                    docker rm jenkins-practice 2>/dev/null || true

                    docker run -d \
                        --name jenkins-practice \
                        -p 8081:8081 \
                        razdeepak/jenkins-practice-01:latest
                '''
            }
        }

        stage('Docker-Images') {
            steps {
                sh 'docker images'
            }
        }
    }

    post {
        success {
            echo 'Build Is Success.'
        }

        failure {
            echo 'Build Failure'
        }
    }
}