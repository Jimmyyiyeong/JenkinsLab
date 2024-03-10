pipeline {
    agent any
    parameters {
        choice(description: 'Which branch do you want to checkout?', name: 'Branches', choices: ['main', 'b1'])
    }

    options {
        skipDefaultCheckout(true)
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: "${params.Branches}", url: "https://github.com/Jimmyyiyeong/JenkinsLab.git"
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
        stage('Stage4') {
            steps {
                echo 'Hello World!'
            }
        }
    }
}