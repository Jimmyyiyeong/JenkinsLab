pipeline {
    agent any
    parameters {
        gitParameter branchFilter: 'origin/(.*)', defaultValue: 'main', name: 'BRANCH', type: 'PT_BRANCH'
    }    
    stages {
        stage('Build Trailrunner') {
            steps {
                dir('Trailrunner') {
                    bat 'mvn clean compile'
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
                   bat 'robot --outputdir testresult --variable browser:headlesschrome BokaBil.robot'
                }
            }
        }
        stage('Robot Result') {
            steps {
                dir('Selenium') {
                    robot outputPath: 'testresult'
                }
            }
            post {
                success {
                    dir('Selenium/testresult') {
                        bat 'del /F /Q *'
                    }
                }
            }
        }       
    }
    post {
        always {
            mail to: 'jimmy.yi.yeong@gmail.com',
                subject: "A build was initiated: ${currentBuild.fullDisplayName} - ${currentBuild.result}",
                body: "Go to link to view details: ${env.BUILD_URL}"
        }
    }
}