pipeline {
    agent any
    
    environment {
        GIT_REPO =          'git@github.com:developer-vs/devops.git'
        GIT_CREDENTIALS =   'Github'
        TF_DIRECTORY_S3 =   'jenkins_in_docker_on_aws/project-setup-files/terraform_s3'
        TF_DIRECTORY =      'jenkins_in_docker_on_aws/project-setup-files/terraform'
        ANSIBLE_DIRECTORY = 'jenkins_in_docker_on_aws/project-setup-files/ansible'
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
                                    sparseCheckoutPaths: [[path: 'jenkins_in_docker_on_aws']]]]])
            }
        }
        
        stage('Check Terraform') {
            steps {
                sh 'terraform --version'
            }
        }
        
        stage('Setup S3 Bucket') {
            steps {
                dir("${TF_DIRECTORY_S3}") {
                    script {
                        sh './setup_s3_bucket.sh'                        
                    }
                }
            }
        }
        
        stage('Setup Project') {
            steps {
                dir("${TF_DIRECTORY}") {
                    script {
                        sh './setup-project.sh'                        
                    }
                }
            }
        }
        
        stage('Check Ansible') {
            steps {
                sh 'ansible --version'
            }
        }
        
        stage('Deploy Docker') {
            steps {
                dir("${ANSIBLE_DIRECTORY}") {
                    script {
                        sh 'ansible-playbook deploy-docker.yml'                        
                    }
                }
            }
        }
        
        stage('Deploy Jenkins') {
            steps {
                dir("${ANSIBLE_DIRECTORY}") {
                    script {
                        sh 'ansible-playbook deploy-jenkins.yml'                        
                    }
                }
            }
        }
    }
}

