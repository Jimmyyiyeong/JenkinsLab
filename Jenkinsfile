pipeline {
    agent any
    environment {
        gitURL = 'https://github.com/Jimmyyiyeong/JenkinsLab.git'
    }
    parameters {
        choice(description: 'Which branch do you want to checkout?', name: 'Branches', choices: ['main', 'b1'])
    }

    options {
        skipDefaultCheckout(true)
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: "${params.Branches}", url: "${gitURL}"
            }
        }
        stage('Build Trailrunner') {
            steps {
                dir('Trailrunner') {
                    bat 'mvn compile'
                }
            }
        }
        stage('Test Trailrunner') {
            steps {
                dir('Trailrunner') {
                    bat 'mvn test'
                }
            }
        }
        stage('Run Robot Framework') {
            steps {
                dir('Selenium') {
                   bat robot --outputdir testresult browser:headlesschrome BokaBil.robot
                }
            }
        }
    }
    post {
        always {
            junit '**/TEST*.xml'
        }
    }
}