pipeline {
    agent any
    parameters {
        choice(description: 'Which branch do you want to checkout?', name: 'Branches', choices: ['main', 'b1'])
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: "${params.Branches}", url: "https://github.com/Jimmyyiyeong/JenkinsLab.git"
            }
        }
        stage('Stage2') {
            steps {
                echo 'Hello World!'
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