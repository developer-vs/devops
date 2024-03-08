pipeline {
    agent any

    stages {
        stage('Destroy Nodejs Apps Terraform state') {
            steps {
                script {
                    dir("../nodejs-apps-deploy/nodejs-apps-2/project-setup-files/terraform") {
                        sh 'ls -l'
                        
                        // Check if tf-cleanup.sh file exists before attempting to change permissions
                        if (fileExists('tf-cleanup.sh')) {
                            sh 'chmod +x tf-cleanup.sh' // Ensure script is executable
                            sh './tf-cleanup.sh' // Execute the script
                        } else {
                            echo "Error: tf-cleanup.sh file not found."
                            // You can choose to exit the stage here or handle the error accordingly
                            exit 0
                        }
                    }
                }
            }
        }
        
        stage('Remove saved Nodejs Apps Terraform state from S3 bucket') {
            steps {
                script {
                    dir("../nodejs-apps-deploy/nodejs-apps-2/project-setup-files/terraform") {
                        sh 'ls -l'
                        
                        // Check if rm-nodejs-apps-tfstate-from-s3.sh file exists before attempting to change permissions
                        if (fileExists('rm-nodejs-apps-tfstate-from-s3.sh')) {
                            sh 'chmod +x rm-nodejs-apps-tfstate-from-s3.sh' // Ensure script is executable
                            sh './rm-nodejs-apps-tfstate-from-s3.sh' // Execute the script
                        } else {
                            echo "Error: rm-nodejs-apps-tfstate-from-s3.sh file not found."
                            // You can choose to exit the stage here or handle the error accordingly
                            exit 0
                        }
                    }
                }
            }
        }

        stage('Remove saved S3 Setup Bucket state from S3 bucket') {
            steps {
                script {
                    dir("../nodejs-apps-deploy/nodejs-apps-2/project-setup-files/setup-s3-bucket") {
                        sh 'ls -l'
                        
                       // Check if remove_s3_bucket.sh file exists before attempting to change permissions
                        if (fileExists('remove_s3_bucket.sh')) {
                            sh 'chmod +x remove_s3_bucket.sh' // Ensure script is executable
                            sh './remove_s3_bucket.sh' // Execute the script
                        } else {
                            echo "Error: remove_s3_bucket.sh file not found."
                            // You can choose to exit the stage here or handle the error accordingly
                            exit 0
                        }
                    }
                }
            }
        }
        
        stage('Destroy S3 Setup Terraform state') {
    steps {
        script {
            dir("../nodejs-apps-deploy/nodejs-apps-2/project-setup-files/setup-s3-bucket") {
                sh 'ls -l'
                
                // Initialize Terraform
                sh 'terraform init'

                // Destroy infrastructure with auto-approval
                sh 'terraform destroy -auto-approve || true'

                // Clean up Terraform-related files
                echo "Removing Terraform-related files..."
                sh 'rm -f terraform.tfstate terraform.tfstate.backup .terraform.lock.hcl tfplan terraform.tfplan'
                sh 'rm -rf .terraform/'
            }
        }
    }
}

        
       stage('Destroy S3 bucket') {
    steps {
        script {
            dir("../nodejs-apps-deploy/nodejs-apps-2/project-setup-files/setup-s3-bucket") {
                def bucketName = sh(script: "grep -E 'resource \"aws_s3_bucket\" \"nodejs_apps_bucket\"' main.tf -A 2 | grep \"bucket =\" | awk -F '\"' '{print \$2}'", 
                                    returnStdout: true).trim()

                if (bucketName) {
                    sh "aws s3api delete-bucket --bucket $bucketName"
                } else {
                    echo "Error: Unable to extract bucket name from main.tf."
                    error("Unable to extract bucket name from main.tf.")
                }
            }
        }
    }
}

        
        stage('Clean Up "nodejs-apps-deploy" project') {
            steps {
                dir("../nodejs-apps-deploy") {
                    deleteDir()
                }
                dir("../nodejs-apps-deploy@tmp") {
                    deleteDir()
                }
            }
        }
        
        stage('Clean Up "nodejs-apps-destroy" project') {
            steps {
                dir("../nodejs-apps-destroy") {
                    deleteDir()
                }
            }
        }
    }
}

