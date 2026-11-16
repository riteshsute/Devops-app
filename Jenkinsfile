
pipeline {

    agent any

    environment {
        AWS_REGION      = 'ap-south-1'
        AWS_ACCOUNT_ID  = '329995585174'
        ECR_REPOSITORY  = 'devops-app'
        IMAGE_TAG       = "${BUILD_NUMBER}"
        ECR_REGISTRY    = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"
        IMAGE_NAME      = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPOSITORY}"
    }

    stages {

        // 1. Checkout source code
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        // 2. Verify Node.js and npm
        
        stage('Check Build Agent') {
            steps {
                sh '''
                    set -e

                    echo "===== AGENT INFORMATION ====="
                    hostname
                    whoami
                    pwd

                    echo "===== INSTALLED TOOLS ====="
                    node --version
                    npm --version
                    aws --version
                    git --version

                    echo "===== BUILDKIT CHECK ====="
                    buildctl --version
                    buildkitd --version
                    rootlesskit --version

                    echo "===== BUILD DIRECTORY ====="
                    ls -ld /home/jenkins/.local/share/buildkit
                '''
            }
        }


        // 3. Install dependencies and test application
        stage('Install Dependencies') {
            steps {
                sh '''
                    set -e

                    echo "===== INSTALLING DEPENDENCIES ====="
                    npm ci

                    echo "Dependencies installed successfully"
                '''
            }
        }

        stage('Test') {
            steps {
                sh '''
                    set -e

                    echo "===== RUNNING APPLICATION TESTS ====="

                    if node -e "process.exit(require('./package.json').scripts?.test ? 0 : 1)"; then
                        npm test
                    else
                        echo "No test script configured in package.json"
                        echo "Skipping application tests"
                    fi
                '''
            }
        }

        // 4. Verify AWS credentials
        stage('Verify AWS Identity') {
            steps {
                sh '''
                    set -e

                    echo "===== VERIFYING AWS IDENTITY ====="

                    aws sts get-caller-identity

                    echo "AWS identity verified"
                '''
            }
        }

        // 5. Login to Amazon ECR
        stage('Login to ECR') {
            steps {
                sh '''
                    set -e

                    echo "===== LOGGING IN TO ECR ====="

                    aws ecr get-login-password \
                        --region "$AWS_REGION" | \
                    docker login \
                        --username AWS \
                        --password-stdin "$ECR_REGISTRY"

                    echo "Successfully logged in to ECR"
                '''
            }
        }

        // 6. Build Docker image
        stage('Build Docker Image') {
            steps {
                sh '''
                    set -e

                    echo "===== BUILDING DOCKER IMAGE ====="

                    docker build \
                        -t "${ECR_REPOSITORY}:${IMAGE_TAG}" \
                        .

                    docker tag \
                        "${ECR_REPOSITORY}:${IMAGE_TAG}" \
                        "${IMAGE_NAME}:${IMAGE_TAG}"

                    echo "Docker image built successfully"

                    docker images
                '''
            }
        }

        // 7. Push image to ECR
        stage('Push Image') {
            steps {
                sh '''
                    set -e

                    echo "===== PUSHING IMAGE TO ECR ====="

                    docker push "${IMAGE_NAME}:${IMAGE_TAG}"

                    echo "Image pushed successfully"
                    echo "${IMAGE_NAME}:${IMAGE_TAG}"
                '''
            }
        }
    }

    post {
        success {
            echo 'DevOps CI pipeline completed successfully!'
            echo 'Application image pushed to Amazon ECR.'
        }

        failure {
            echo 'DevOps CI pipeline failed. Check the failed stage in Console Output.'
        }

        always {
            echo 'Jenkins pipeline execution finished.'
        }
    }
}
