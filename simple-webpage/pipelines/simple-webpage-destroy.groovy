pipeline {
    agent any

    stages {        
        stage('Ansible Playbook Apply') {
            steps {
                script {
                    dir("../simple-webpage-deploy/simple-webpage/scripts") {
                        sh 'ls -l' // List files in the directory for debugging
                        
                        // Check if tf-cleanup.sh file exists before attempting to change permissions
                        if (fileExists('tf-cleanup.sh')) {
                            sh 'chmod +x tf-cleanup.sh' // Ensure script is executable
                            sh './tf-cleanup.sh' // Execute the script
                        } else {
                            echo "Error: tf-cleanup.sh file not found."
                            // You can choose to exit the stage here or handle the error accordingly
                        }
                    }
                }
            }
        }
        
        stage('Clean Up "simple-webpage-deploy" project') {
            steps {
                dir("../simple-webpage-deploy") {
                    deleteDir()
                }
            }
        }
        
        stage('Clean Up "simple-webpage-destroy" project') {
            steps {
                dir("../simple-webpage-destroy") {
                    deleteDir()
                }
            }
        }
    }
}

