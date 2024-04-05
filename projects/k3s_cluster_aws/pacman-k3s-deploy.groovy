pipeline {
    agent any
    
    options {
        ansiColor('xterm')
    }
    
    environment {
        GIT_REPO            = 'git@github.com:developer-vs/devops.git'
        GIT_CREDENTIALS     = 'Github'
        TF_DIRECTORY_S3     = 'projects/k3s_cluster_aws/cluster_init/terraform/s3_bucket_config'
        TF_DIRECTORY_VPC    = 'projects/k3s_cluster_aws/cluster_init/terraform/main_vpc_config'
        TF_DIRECTORY_MASTER = 'projects/k3s_cluster_aws/cluster_init/terraform/master_node_config'
        TF_DIRECTORY_WORKER = 'projects/k3s_cluster_aws/cluster_init/terraform/worker_node_config'
        ANSIBLE_DIRECTORY   = 'projects/k3s_cluster_aws/cluster_init/ansible'
    }

    stages {
        stage('Clone Git repo') {
            steps {
                deleteDir()
                sh 'ssh-keyscan -H github.com >> $HOME/.ssh/known_hosts'
                checkout([$class: 'GitSCM',
                          branches: [[name: 'dev']],
                          userRemoteConfigs: [[credentialsId: "${GIT_CREDENTIALS}", url: "${GIT_REPO}"]],
                          extensions: [[$class: 'SparseCheckoutPaths', sparseCheckoutPaths: [[path: 'projects/k3s_cluster_aws/cluster_init/']]]]])
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
        
        stage('Terraform Plan - Main VPC') {
            steps {
                script {
                    dir("${TF_DIRECTORY_VPC}") {
                        sh '''
                            terraform init -input=false
                            terraform plan -out=terraform.tfplan
                        '''
                    }
                }
            }
        }
        
        stage('Approval - Main VPC') {
            steps {
                input(
                    message: 'Review the main VPC plan. Proceed with apply?',
                    ok: 'Proceed'
                )
            }
        }
        
        stage('Terraform Apply - Main VPC') {
            steps {
                script {
                    dir("${TF_DIRECTORY_VPC}") {
                        sh '''
                            terraform apply -input=false terraform.tfplan
                        '''
                    }
                }
            }
        }
        
        stage('Terraform Plan - Master Node') {
            steps {
                script {
                    dir("${TF_DIRECTORY_MASTER}") {
                        sh '''
                            terraform init -input=false
                            terraform plan -out=terraform.tfplan
                        '''
                    }
                }
            }
        }
        
        stage('Approval - Master Node') {
            steps {
                input(
                    message: 'Review the master node plan. Proceed with apply?',
                    ok: 'Proceed'
                )
            }
        }
        
        stage('Check JQ') {
            steps {
                sh 'jq --version'
            }
        }
        
        stage('Terraform Apply - Master Node') {
            steps {
                script {
                    dir("${TF_DIRECTORY_MASTER}") {
                        sh '''
                            # Apply Terraform changes
                            terraform apply -input=false terraform.tfplan

                            # Retrieve private and public IP addresses
                            private_ip=$(terraform output -json k3s_master_instance_private_ip | jq -r '.[]')
                            public_ip=$(terraform output -json k3s_master_instance_public_ip | jq -r '.[]')

                            # Create or update hosts.ini
                            {
                                echo "[master_private]"
                                echo "$private_ip"
                                echo ""
                                echo "[master_public]"
                                echo "$public_ip ssh_private_key=../terraform/master_node_config/k3s-master.pem"
                            } > ./hosts.ini
                        '''
                    }
                }
            }
        }
        
        stage('Terraform Plan - Worker Nodes') {
            steps {
                script {
                    dir("${TF_DIRECTORY_WORKER}") {
                        sh '''
                            terraform init -input=false
                            terraform plan -out=terraform.tfplan
                        '''
                    }
                }
            }
        }
        
        stage('Approval - Worker Nodes') {
            steps {
                input(
                    message: 'Review the worker nodes plan. Proceed with apply?',
                    ok: 'Proceed'
                )
            }
        }
        
        stage('Terraform Apply - Worker Nodes') {
            steps {
                script {
                    dir("${TF_DIRECTORY_WORKER}") {
                        sh '''
                            # Apply Terraform changes
                            terraform apply -input=false terraform.tfplan
                    
                            # Delay for stability
                            sleep 60

                            # Run Terraform command to get private IP addresses for workers
                            worker_private_ips=$(terraform output -json k3s_workers_instance_private_ip | jq -r '.[]')

                            # Update hosts.ini with worker_private section
                            echo "" >> ./hosts.ini
                            echo "[worker_private]" >> ./hosts.ini
                            for ip in $worker_private_ips; do
                                echo "$ip ssh_private_key=../terraform/worker_node_config/k3s-worker.pem" >> ./hosts.ini
                            done
                        '''
                    }
                }
            }
        }
        
        stage('Check Ansible') {
            steps {
                sh 'ansible --version'
            }
        }
        
        stage('Run Ansible Playbooks') {
            steps {
                script {
                    dir("${ANSIBLE_DIRECTORY}") {
                        sh '''
                            ansible-playbook master_setup.yml
                            ansible-playbook worker_setup.yml
                        '''
                    }
                }
            }
        }
    }
}

