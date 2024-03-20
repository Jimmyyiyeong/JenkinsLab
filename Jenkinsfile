pipeline {
    agent any
    variables {
        pathToExecPattern = '**/target/jacoco.exec'
        pathToClassPattern = '**/target/classes/se/iths'
        pathToSourcePattern = '**/src/main/java/se/ith'
        pathToJunitTestResults = '**/target/surefire-reports/TEST*.xml'
    }
    stages {
        stage('Build Trailrunner') {
            steps {
                dir('Trailrunner') {
                    bat 'mvn clean compile'
                }
            }
        }
        stage ('Analyse Trailrunner Code') {
            steps {
                dir('Trailrunner') {
                    bat 'mvn spotbugs:spotbugs'
                }
            }
        }
        stage ('Publish Analyse Report') {
            steps {
                dir('Trailrunner') {
                    script {
                        def issues = scanForIssues tool: spotBugs(pattern: '**/target/spotbugsXml.xml')
                        publishIssues([issues])
                    }
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
                execPattern: "${pathToExecPattern}",
                classPattern: "${pathToClassPattern}",
                sourcePattern: "${pathToSourcePattern}"
                )
                junit "${pathToJunitTestResults}"
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
