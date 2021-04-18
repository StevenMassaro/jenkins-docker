pipeline {
    agent {
        label 'master'
    }

    stages {
        stage('Pre-build') {
            steps {
                sh 'curl https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage -d chat_id=${TELEGRAM_CHAT_ID} -d text="${JOB_BASE_NAME} - ${BUILD_NUMBER} started" || true'
            }
        }
        stage('Docker') {
            steps {
                script {
                    image = docker.build("stevenmassaro/jenkins-docker:latest")
                    docker.withRegistry('', 'DockerHub') {
                        image.push()
                        image.push(env.BUILD_NUMBER)
                    }
                }
            }
        }
        stage('Results') {
            steps {
                sh 'curl https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage -d chat_id=${TELEGRAM_CHAT_ID} -d text="${JOB_BASE_NAME} - ${BUILD_NUMBER} finished" || true'
            }
        }
    }
}