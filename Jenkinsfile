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
        stage('Clean Workspace') {
            steps {
                cleanWs()
            }
        }   
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
        stage('Trailrunner Result') {
            steps {
                jacoco(
                execPattern: '**/target/jacoco.exec',
                classPattern: '**/target/classes/se/iths',
                sourcePattern: '**/src/main/java/se/iths'
                )
                junit '**/target/surefire-reports/TEST*.xml'
            }
        }    
        stage('Run Robot Framework') {
            steps {
                dir('Selenium') {
                   bat 'robot --outputdir testresult --variable browser:headlesschrome --nostatusrc BokaBil.robot'
                }
            }
        }
        stage('Robot Result') {
            steps {
                dir('Selenium') {
                    robot outputPath: 'testresult'
                }
            }
        }
    }
    post {
        always {
            emailext(
                subject: "Build ${currentBuild.fullDisplayName} ${currentBuild.result}",
                body: "Build ${currentBuild.fullDisplayName} has finished with status: ${currentBuild.result}",
                to: "jimmy.yiyeong@iths.se",
                replyTo: "jimmy.yiyeong@iths.se",
                mimeType: 'text/html'
            )
        }
    }
}