pipeline {
    agent any   // Runs on any available agent

    environment {
        MAVEN_HOME = tool 'Maven 3.9.10'  // Name from Global Tool Configuration
        PATH = "${MAVEN_HOME}/bin:${env.PATH}"
    }

    options {
        timestamps()  // Adds timestamps to the console output
        buildDiscarder(logRotator(numToKeepStr: '5'))  // Keep only last 10 builds
    }

    triggers {
        githubPush()  // Trigger build on GitHub push event (webhook)
    }

    tools {
        maven 'Maven 3.9.10'  // Tool name must match what's configured in Jenkins
        // Optionally use: jdk 'JDK11'
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/suryateja010/maven-sample-app.git'
            }
        }

        stage('Build') {
            steps {
                sh 'mvn clean compile'
            }
        }

        stage('Test') {
            steps {
                sh 'mvn test'
            }
            post {
                always {
                    junit 'target/surefire-reports/*.xml'  // Publish test results
                }
            }
        }

        stage('Package') {
            steps {
                sh 'mvn package -DskipTests'
            }
        }

        stage('Archive Artifacts') {
            steps {
                archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
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
            cleanWs()  // Clean workspace after build
        }
    }
}
