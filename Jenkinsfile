pipeline {

    agent any

    environment {
        AWS_REGION = 'ap-south-1'
        ECR_REPOSITORY = 'devops-app'
        AWS_ACCOUNT_ID = '329995585174'
        IMAGE_TAG = "${BUILD_NUMBER}"
        ECR_REGISTRY = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Test') {
            steps {
                sh '''
                    echo "===== TEST STAGE ====="

                    echo "PATH:"
                    echo $PATH

                    echo "Checking Node..."
                    which node || true
                    node --version || true

                    echo "Checking npm..."
                    which npm || true
                    npm --version || true

                    echo "Checking files..."
                    pwd
                    ls -la
                '''
            }
        }

        
        stage('Build Docker Image') {
            steps {
                sh '''
                    echo "===== DOCKER DEBUG ====="

                    echo "Checking Docker CLI..."
                    which docker || echo "DOCKER CLI NOT FOUND"

                    echo "Docker version..."
                    docker --version || echo "DOCKER COMMAND FAILED"

                    echo "Docker info..."
                    docker info || echo "DOCKER DAEMON NOT AVAILABLE"

                    echo "Current directory..."
                    pwd

                    echo "Files..."
                    ls -la
                '''
            }
        }


        
        stage('Login to ECR') {
            steps {
                sh '''
                    echo "===== AWS CLI DEBUG ====="

                    echo "Checking AWS CLI..."
                    which aws || echo "AWS CLI NOT FOUND"

                    echo "AWS version..."
                    aws --version || echo "AWS COMMAND FAILED"

                    echo "Checking Docker..."
                    docker --version

                    echo "AWS region:"
                    echo ${AWS_REGION}

                    echo "ECR registry:"
                    echo ${ECR_REGISTRY}
                '''
            }
        }


        stage('Push Image') {
            steps {
                sh '''
                    echo "===== PUSH IMAGE ====="

                    docker tag \
                    ${ECR_REPOSITORY}:${IMAGE_TAG} \
                    ${ECR_REGISTRY}/${ECR_REPOSITORY}:${IMAGE_TAG}

                    docker push \
                    ${ECR_REGISTRY}/${ECR_REPOSITORY}:${IMAGE_TAG}
                '''
            }
        }
    }

    post {
        success {
            echo 'DevOps CI pipeline completed successfully!'
        }

        failure {
            echo 'DevOps CI pipeline failed.'
        }
    }
}
