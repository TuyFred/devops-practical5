
pipeline {
    agent any

    triggers {
        pollSCM('H/2 * * * *')
    }

    options {
        skipDefaultCheckout()
        disableConcurrentBuilds()
    }

    stages {

        stage('Clone') {
            steps {
                echo 'Cloning source code from GitHub...'
                checkout scm
            }
        }

        stage('Install') {
            steps {
                echo 'Checking Node.js and npm versions...'
                sh 'node --version'
                sh 'npm --version'

                echo 'Installing project dependencies...'
                sh 'npm ci'
            }
        }

        stage('Test') {
            steps {
                echo 'Running application tests...'
                sh 'npm test'

                echo 'Generating JUnit test report...'
                sh 'npm run test:report'
            }

            post {
                always {
                    junit allowEmptyResults: true,
                          testResults: 'test-results.xml'
                }
            }
        }

        stage('Build') {
            steps {
                echo 'Building the application...'
                sh 'npm run build'
                sh 'ls -la dist'
            }
        }

        stage('Deploy to Staging') {
            steps {
                echo 'Deploying application to staging...'
                sh 'npm run deploy:staging'
            }
        }
    }

    post {
        success {
            archiveArtifacts artifacts: 'dist/**',
                             fingerprint: true

            echo 'Pipeline completed successfully.'
        }

        failure {
            echo 'Pipeline failed. Check Console Output for details.'
        }
    }
}
