pipeline {
    agent any

    environment {
        MAVEN_HOME = tool 'Maven 3.9.10'
        PATH = "${MAVEN_HOME}/bin:${env.PATH}"
        DOCKERHUB_CREDENTIALS = 'dockerhub-credentials-id'  // Jenkins credentials ID for Docker Hubs
        DOCKER_IMAGE = "surya01021/maven-sample-project"
        IMAGE_TAG = "${env.BUILD_NUMBER}"
    }

    options {
        timestamps()
        buildDiscarder(logRotator(numToKeepStr: '10'))
    }

    triggers {
        githubPush()
    }

    tools {
        maven 'Maven 3.9.10'
         dockerTool 'Docker 28'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/suryateja010/maven-sample-app.git'
            }
        }

        stage('Docker Build') {
            steps {
                script {
                    sh "docker build -t ${DOCKER_IMAGE}:${IMAGE_TAG} ."
                }
            }
        }

        stage('Publish to Docker Hub') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: DOCKERHUB_CREDENTIALS,
                                                     usernameVariable: 'DOCKERHUB_USER',
                                                     passwordVariable: 'DOCKERHUB_PASS')]) {
                        sh "echo $DOCKERHUB_PASS | docker login -u $DOCKERHUB_USER --password-stdin"
                        sh "docker push ${DOCKER_IMAGE}:${IMAGE_TAG}"
                        sh "docker logout"
                    }
                }
            }
        }
    }

    post {
        success {
            echo 'Pipeline succeeded!'
            // notifySlack(status: 'success')
        }
        failure {
            echo 'Pipeline failed!'
            // notifySlack(status: 'failure')
        }
        always {
            cleanWs()
        }
    }
}
