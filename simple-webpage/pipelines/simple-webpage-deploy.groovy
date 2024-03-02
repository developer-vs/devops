pipeline {
    agent any

    stages {
        stage('Clone Github Repository') {
            steps {
                deleteDir()
                sh 'ssh-keyscan -H github.com >> $HOME/.ssh/known_hosts'
                git branch: 'main',
                    credentialsId: 'Github',
                    url: 'git@github.com:developer-vs/devops.git'
            }
        }
        
        stage('Check Terraform') {
            steps {
                sh 'terraform --version'
            }
        }
        
        stage('Terraform Plan') {
            steps {
                script {
                    dir("$WORKSPACE/simple-webpage/terraform") {
                        sh 'terraform init'
                        sh 'terraform plan -out=terraform.tfplan'
                    }
                }
            }
        }
        
        stage('Plan verification and user input') {
            steps {
                input(
                    message: 'Proceed or abort?', 
                    ok: 'ok'
                )
            }
        }
        
        stage('Terraform Apply') {
            steps {
                script {
                    dir("$WORKSPACE/simple-webpage/terraform") {
                        sh 'terraform apply terraform.tfplan'
                    }
                }
            }
        }
        
        stage('Get IP Address') {
            steps {
                script {
                    dir("$WORKSPACE/simple-webpage/terraform") {
                        sh 'terraform output web_address > $WORKSPACE/simple-webpage/ansible/instance_ip.txt'
                        def fileContent = readFile("$WORKSPACE/simple-webpage/ansible/instance_ip.txt").trim()
                        echo "IP address: $fileContent"
                    }
                }
            }
        }

        stage('Check Ansible') {
            steps {
                sh 'ansible --version'
            }
        }
        
        stage('Ansible Playbook verification and user input') {
            steps {
                input(
                    message: 'Proceed or abort?', 
                    ok: 'ok'
                )
            }
        }
        
        stage('Ansible Playbook Apply') {
            steps {
                script {
                    dir("$WORKSPACE/simple-webpage/scripts") {
                        sh 'ls -l' // List files in the directory for debugging
                        sh 'chmod +x run_playbook.sh' // Ensure script is executable
                        sh './run_playbook.sh' // Execute the script
                    }
                }
            }
        }
    }
}

