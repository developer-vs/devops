pipeline {
    agent any

    stages {
        stage('Destroy Nodejs app Terraform state') {
            steps {
                script {
                    dir("../dadjokes-deploy/nodejs_apps/project_setup_files/scripts") {
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
        
        stage('Remove Nodejs app Terraform state from bucket') {
            steps {
                script {
                    dir("../dadjokes-deploy/nodejs_apps/project_setup_files/terraform") {
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
        
        stage('Destroy Terraform S3 bucket') {
            steps {
                script {
                    dir("../dadjokes-deploy/nodejs_apps/project_setup_files/setup-s3-bucket") {
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
        
        stage('Clean Up "dadjokes-deploy" project') {
            steps {
                dir("../dadjokes-deploy") {
                    deleteDir()
                }
                dir("../dadjokes-deploy@tmp") {
                    deleteDir()
                }
            }
        }
        
        stage('Clean Up "dadjokes-destroy" project') {
            steps {
                dir("../dadjokes-destroy") {
                    deleteDir()
                }
            }
        }
    }
}

