pipeline {
    agent any
    parameters {
        choice(description: 'Which branch do you want to checkout?', name: 'Branches', choices: ['main', 'b1'])
    }

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/Jimmyyiyeong/JenkinsLab.git'
                echo 'Branch: '${params.Branches}''
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