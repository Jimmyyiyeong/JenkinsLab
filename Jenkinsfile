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
                dir('Trailrunner')
                    bat 'maven compile'
            }
        }
        stage('Stage3') {
            steps {
                echo 'Hello World!'
            }
        }
        stage('Stage4') {
            steps {
                echo 'Hello World!'
            }
        }
    }
}