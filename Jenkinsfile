pipeline {
    agent any
    environment {
        gitURL = 'https://github.com/Jimmyyiyeong/JenkinsLab.git'
    }
    parameters {
        choice choices: ['main', 'b1'], description: 'Which branch do you want to checkout?', name: 'Branches'
    }
    options {
        skipDefaultCheckout()
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
                   bat 'robot --outputdir testresult --variable browser:headlesschrome BokaBil.robot'
                }
            }
        }
    }
    post {
        always {
            jacoco(
                execPattern: '**/target/jacoco.exec',
                classPattern: '**/target/classes/se/iths',
                sourcePattern: '**/src/main/java/se/iths'
                )
            junit '**/TEST*.xml'
            dir('Selenium') {
                robot outputPath: 'testresult'
            }
        }
    }
}