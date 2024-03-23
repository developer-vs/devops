pipeline {
    agent any
    
    environment {
        GIT_REPO = 'git@github.com:developer-vs/devops.git'
        GIT_CREDENTIALS = 'Github'
        TF_DIRECTORY_S3 = 'project-setup-files/terraform_s3'
        TF_DIRECTORY = 'project-setup-files/terraform'
    }
    
    stages {
        stage('Destroy Jenkins Terraform state') {
            steps {
                dir("${TF_DIRECTORY}") {
                    sh './rm-jenkins-server-tfstate.sh'
                }
            }
        }
        
        stage('Remove Jenkins Terraform state from S3 bucket') {
            steps {
                dir("${TF_DIRECTORY}") {
                    sh './rm-s3-jenkins-server-tfstate.sh'
                }
            }
        }
        
        stage('Remove S3 Bucket') {
            steps {
                dir("${TF_DIRECTORY_S3}") {
                    sh 'echo "y" | ./remove_s3_bucket.sh'
                }
            }
        }
        
        stage('Clean Up "jenkins-aws-deploy" project') {
            steps {
                deleteDir(dir: "../jenkins-aws-deploy")
                deleteDir(dir: "../jenkins-aws-deploy@tmp")
            }
        }
        
        stage('Clean Up "jenkins-aws-destroy" project') {
            steps {
                deleteDir(dir: "../jenkins-aws-destroy")
                deleteDir(dir: "../jenkins-aws-destroy@tmp")
            }
        }
    }
}

