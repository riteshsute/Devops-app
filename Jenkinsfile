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
                    echo "Current directory:"
                    pwd

                    echo "Files:"
                    ls -la

                    echo "Installing dependencies..."
                    npm install

                    echo "Checking server.js syntax..."
                    node --check server.js
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                    echo "===== DOCKER BUILD ====="

                    docker build \
                    -t ${ECR_REPOSITORY}:${IMAGE_TAG} \
                    .
                '''
            }
        }

        stage('Login to ECR') {
            steps {
                sh '''
                    echo "===== ECR LOGIN ====="

                    aws ecr get-login-password \
                    --region ${AWS_REGION} |
                    docker login \
                    --username AWS \
                    --password-stdin ${ECR_REGISTRY}
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
