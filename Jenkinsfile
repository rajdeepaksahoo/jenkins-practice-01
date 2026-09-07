pipeline {

    agent any

    options {
        timestamps()
        disableConcurrentBuilds()
        skipDefaultCheckout(true)
        buildDiscarder(
                logRotator(
                        numToKeepStr: '20',
                        artifactNumToKeepStr: '10'
                )
        )
        timeout(time: 15, unit: 'MINUTES')
    }

    environment {
        APP_NAME = 'jenkins-practice-01'
        APP_PORT = '8081'
        JAR_FILE = 'target/jenkins-practice-01-*.jar'
        PID_FILE = 'application.pid'
        LOG_FILE = 'application.log'
    }

    stages {

        /*
         * =========================
         * CHECKOUT
         * =========================
         */
        stage('Checkout') {
            steps {
                echo 'Checking out source code...'
                checkout scm
            }
        }

        /*
         * =========================
         * BUILD
         * =========================
         */
        stage('Build') {
            steps {
                echo 'Building Spring Boot application...'

                sh '''
                    chmod +x mvnw
                    ./mvnw clean package -DskipTests
                '''
            }
        }

        /*
         * =========================
         * TEST
         * =========================
         */
        stage('Test') {
            steps {
                echo 'Running unit tests...'

                sh '''
                    ./mvnw test
                '''
            }

            post {
                always {
                    junit(
                            allowEmptyResults: true,
                            testResults: 'target/surefire-reports/*.xml'
                    )
                }
            }
        }

        /*
         * =========================
         * PACKAGE
         * =========================
         */
        stage('Package') {
            steps {
                echo 'Packaging application...'

                sh '''
                    ls -lh target/*.jar
                '''

                archiveArtifacts(
                        artifacts: 'target/*.jar',
                        fingerprint: true
                )
            }
        }

        /*
         * =========================
         * DEPLOY
         * =========================
         */
        stage('Deploy') {
            steps {
                echo "Deploying ${APP_NAME}..."

                sh '''
                    # Stop previous application if running
                    if [ -f "$PID_FILE" ]; then

                        PID=$(cat "$PID_FILE")

                        if kill -0 "$PID" 2>/dev/null; then
                            echo "Stopping existing application: PID=$PID"

                            kill "$PID"

                            # Give application time to shutdown
                            sleep 5

                            # Force kill if still running
                            if kill -0 "$PID" 2>/dev/null; then
                                echo "Application did not stop gracefully."
                                kill -9 "$PID"
                            fi
                        fi

                        rm -f "$PID_FILE"
                    fi

                    echo "Starting new application..."

                    nohup java -jar $JAR_FILE \
                        --server.port=$APP_PORT \
                        > "$LOG_FILE" 2>&1 &

                    echo $! > "$PID_FILE"

                    echo "Application started with PID=$(cat $PID_FILE)"
                '''
            }
        }

        /*
         * =========================
         * HEALTH CHECK
         * =========================
         */
    }

    /*
     * =========================
     * POST ACTIONS
     * =========================
     */
    post {

        success {
            echo "======================================"
            echo "Deployment successful"
            echo "Application : ${APP_NAME}"
            echo "Port        : ${APP_PORT}"
            echo "Build       : ${BUILD_NUMBER}"
            echo "======================================"
        }

        failure {
            echo "======================================"
            echo "Pipeline FAILED"
            echo "Build       : ${BUILD_NUMBER}"
            echo "Check Jenkins console and application logs."
            echo "======================================"
        }

        always {
            echo 'Cleaning workspace...'
            cleanWs()
        }
    }
}