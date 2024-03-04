pipeline {
    agent any

    parameters {
        string(name: 'ACTION', defaultValue: 'abort', description: 'Action to take')
    }

    tools {
        terraform 'tf1.6'
    }

    environment {
        GIT_REPO = 'git@github.com:LocalCoding/DevOps_Jan_24.git'
        GIT_CREDENTIALS = 'jenkins_access_to_git'
        TF_DIRECTORY = 'Lesson_14_Jenkins_pipelines_NodeJS_Apps/project_setup_files/terraform'
    }

    stages {

        stage('Clone Git repo') {
            steps {
                checkout scm: [
                    $class: 'GitSCM',
                    branches: [[name: 'main']],
                    userRemoteConfigs: [[
                        url: "${GIT_REPO}",
                        credentialsId: "${GIT_CREDENTIALS}"
                    ]]
                ]
            }
        }

        stage('Terraform Init & Plan') {
            steps {
                dir("${TF_DIRECTORY}") {
                    sh '''
                    terraform init -input=false
                    terraform plan -destroy -out=terraform_destroy.tfplan
                    '''
                }
            }
        }

        stage('User Approval') {
            steps {
                script {
                    timeout(time: 5, unit: 'MINUTES') {
                        def userInput = input(
                            id: 'userInput', 
                            message: 'Choose to proceed with the build:', 
                            parameters: [choice(name: 'Proceed?', choices: ['yes', 'abort'], description: 'Proceed or Abort')]
                        )
                        if (userInput == 'abort') {
                            error('Build was aborted by the user.')
                        }
                    }
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                dir("${TF_DIRECTORY}") {
                    sh 'terraform apply -input=false terraform_destroy.tfplan'
                }
            }
        }
    }
}