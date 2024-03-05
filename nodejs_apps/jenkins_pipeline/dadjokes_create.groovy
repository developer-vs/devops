pipeline {
    agent any

    parameters {
        string(name: 'ACTION', defaultValue: 'abort', description: 'Action to take')
        choice(name: 'SLEEP', choices: ['yes', 'no'], description: 'Sleep before Ansible Playbook?')
    }

    environment {
        GIT_REPO =          'git@github.com:developer-vs/devops.git'
        GIT_CREDENTIALS =   'Github'
        TF_DIRECTORY_S3 =   'nodejs_apps/setup-s3-bucket'
        TF_DIRECTORY =      'nodejs_apps/project_setup_files/terraform'
        ANSIBLE_DIRECTORY = 'nodejs_apps/project_setup_files/ansible'
    }

    stages {
        stage('Clone Git repo') {
            steps {
                deleteDir()
                checkout([$class: 'GitSCM',
                  branches: [[name: 'main']],
                        userRemoteConfigs: [[
                        credentialsId: "${GIT_CREDENTIALS}",
                        url: "${GIT_REPO}"]],
                        extensions: [[$class: 'SparseCheckoutPaths',
                                    sparseCheckoutPaths: [[path: 'nodejs_apps']]]]])
            }
        }

        stage('Check Terraform') {
            steps {
                sh 'terraform --version'
            }
        }
        
        stage('Terraform Setup S3 Bucket') {
            steps {
                script {
                    dir("${TF_DIRECTORY_S3}") {
                        sh 'chmod +x setup_s3_bucket.sh'
                        sh './setup_s3_bucket.sh'
                    }
                }
            }
        }
        
        stage('Terraform Setup DadJokes Project') {
            steps {
                script {
                    dir("${TF_DIRECTORY}") {
                        sh 'terraform init'
                        sh 'terraform plan -out=terraform.tfplan'
                    }
                }
            }
        }
        
        stage('User Approval for Terraform') {
            steps {
                script {
                    timeout(time: 5, unit: 'MINUTES') {
                        def userInput = input(
                            id: 'userInput',
                            message: 'Proceed with Terraform apply?',
                            parameters: [choice(name: 'Proceed?', choices: ['yes', 'abort'], description: 'Proceed or Abort')]
                        )
                        if (userInput == 'abort') {
                            error('Terraform apply was aborted by the user.')
                        }
                    }
                }
            }
        }
        
        stage('Terraform Apply') {
            steps {
                dir("${TF_DIRECTORY}") {
                    sh 'terraform apply "terraform.tfplan"'
                }
            }
        }
        
        stage('Get Instance IP') {
            steps {
                dir("${TF_DIRECTORY}") {
                    sh 'terraform output web-address-nodejs > ../ansible/instance_ip.txt'
                    sh 'cat ../ansible/instance_ip.txt'
                }
            }
        }

        stage('Check Ansible') {
            steps {
                sh 'ansible --version'
            }
        }
        
        stage('User Approval for Ansible') {
            steps {
                script {
                    timeout(time: 2, unit: 'MINUTES') {
                        def userConfirmation = input(
                            id: 'ConfirmAnsibleRun',
                            message: 'Proceed with Ansible playbook execution?',
                            parameters: [choice(name: 'Confirm', choices: ['yes', 'no'], description: 'Confirm to run Ansible without timeout')],
                            defaultValue: 'yes'
                        )
                        if (userConfirmation == 'no') {
                            error('Ansible playbook execution was aborted by the user.')
                        }
                    }
                }
            }
        }
        
        stage('Run Ansible for the DadJokes App') {
            steps {
                dir("${ANSIBLE_DIRECTORY}") {
                    script {
                        sh 'ansible-playbook playbook_nodejs_dadjokes.yaml'                        
                    }
                }
            }
        }
    }
}

