def Build_pass = true
def Deploy_to_Dev_pass = true
def UnitTest_pass = true
def Deploy_to_QA_pass = true
def E2e_tests_pass = true

pipeline {
    agent any

    stages {
        stage('Build1') {
            steps {
                script {
                    try {
                        if (fileExists('C:/Docs/CMU/Job Prep/QA/CICD/Build_Files/Build.zip')) {
                            bat '''
                            cd C:/Docs/CMU/Job Prep/QA/CICD/Build_Files
                            del /f Build1.zip
                            '''
                        } else {
                            echo 'No Build1.zip Found'
                        }

                        checkout scmGit(branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/vks5639/Online_Fruits_And_Veggies_DEVOPS.git']])
                        
                        fileOperations([
                            fileZipOperation(folderPath: 'C:/ProgramData/Jenkins/.jenkins/workspace/Building_Pipeline_Script_main', outputFolderPath: 'C:/Docs/CMU/Job Prep/QA/CICD/Build_Files'),
                            fileRenameOperation(destination: 'C:/Docs/CMU/Job Prep/QA/CICD/Build_Files/Build1.zip', source: 'C:/Docs/CMU/Job Prep/QA/CICD/Build_Files/Building_Pipeline_Script_main.zip')
                        ])
                    } catch (Exception e) {
                        Build_pass = false
                    }
                }
            }
        }

        stage('DeployToDev') {
            steps {
                script {
                    try {
                        if (Build_pass) {
                            bat '''
                            cd C:/Users/vikas/Desktop
                            scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i "Devops.pem" "C:/Docs/CMU/Job Prep/QA/CICD/Build_Files/Build1.zip" ec2-user@ec2-18-223-124-133.us-east-2.compute.amazonaws.com:/home/ec2-user/EAPP
                            ssh -o "StrictHostKeyChecking no" -i "Devops.pem" ec2-user@ec2-18-223-124-133.us-east-2.compute.amazonaws.com "cd EAPP; sh deployment.sh"
                            '''
                        }
                    } catch (Exception e) {
                        Deploy_to_Dev_pass = false
                    }
                }
            }
        }

        stage('UnitTests') {
            steps {
                script {
                    if (Deploy_to_Dev_pass) {
                        try {
                            checkout scmGit(branches: [[name: '*/master']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/vks5639/unit_test.git']])
                            bat 'mvn -f CICD_Demo/pom.xml clean test'
                        } catch (Exception e) {
                            UnitTest_pass = false
                        }
                    }
                }
            }
        }

        stage('DeployToQA') {
            steps {
                script {
                    try {
                        if (UnitTest_pass) {
                            bat '''
                            cd C:/Users/vikas/Desktop
                            scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i "Devops.pem" "C:/Docs/CMU/Job Prep/QA/CICD/Build_Files/Build1.zip" ec2-user@ec2-18-223-124-133.us-east-2.compute.amazonaws.com:/home/ec2-user/EAPP
                            ssh -o "StrictHostKeyChecking no" -i "Devops.pem" ec2-user@ec2-18-223-124-133.us-east-2.compute.amazonaws.com "cd EAPP; sh deployment.sh"
                            '''
                        }
                    } catch (Exception e) {
                        Deploy_to_QA_pass = false
                    }
                }
            }
        }

        stage('E2ETests') {
            steps {
                script {
                    if (Deploy_to_QA_pass) {
                        try {
                            checkout scmGit(branches: [[name: '*/master']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/vks5639/unit_test.git']])
                            bat 'mvn -f CICD_Demo/pom.xml clean test'
                        } catch (Exception e) {
                            E2e_tests_pass = false
                        }
                    }
                }
            }
        }

        stage('ReleaseToProd') {
            steps {
                script {
                    try {
                        if (E2e_tests_pass) {
                            bat '''
                            cd C:/Users/vikas/Desktop
                            scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i "Devops.pem" "C:/Docs/CMU/Job Prep/QA/CICD/Build_Files/Build1.zip" ec2-user@ec2-18-223-124-133.us-east-2.compute.amazonaws.com:/home/ec2-user/EAPP
                            ssh -o "StrictHostKeyChecking no" -i "Devops.pem" ec2-user@ec2-18-223-124-133.us-east-2.compute.amazonaws.com "cd EAPP; sh deployment.sh"
                            '''
                        }
                    } catch (Exception e) {
                        console.log(e)
                    }
                }
            }
        }
    }
}
