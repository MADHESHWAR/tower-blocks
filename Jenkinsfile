pipeline {
    agent any

    environment {
        IMAGE_NAME = "portfolio-app"
        CONTAINER_NAME = "portfolio-container"
        PORT = "8085"
    }

    stages {

        stage('Checkout') {
            steps {
                echo 'Code checkout done'
            }
        }
        stage('Build Docker Image') {
            steps {
                bat 'docker build -t %IMAGE_NAME% .'
            }
        }

        stage('Run Docker Container') {
            steps {
                bat '''
                docker rm -f %CONTAINER_NAME% 2>nul
                docker run -d -p %PORT%:80 --name %CONTAINER_NAME% %IMAGE_NAME%
                '''
            }
        }

        stage('Terraform Init') {
            steps {
                dir('terraform') {
                    bat 'terraform init'
                }
            }
        }

        stage('Terraform Destroy (Clean old)') {
            steps {
                dir('terraform') {
                    bat 'terraform destroy -auto-approve'
                }
            }
        }

        stage('Terraform Apply (Deploy)') {
            steps {
                dir('terraform') {
                    bat '''terraform apply -auto-approve ^-var "container_name=portfolio-container" ^-var "image_name=nginx:latest" ^-var "external_port=8085"'''
                }
            }
        }
    }
}