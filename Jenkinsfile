
pipeline {
    agent any

    environment {
        KUBECONFIG = '/var/lib/jenkins/.kube/config'
        IMAGE_TAG = "${BUILD_NUMBER}"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/ajivp/DevOpsProject3.git'
            }
        }

        stage('Validate') {
            steps {
                sh '''
                    set -eu
                    for service in frontend product-service cart-service order-service; do
                        echo "Validating $service"
                        cd "services/$service"
                        npm ci
                        npm test
                        cd ../..
                    done
                '''
            }
        }

        stage('Build Images') {
            steps {
                sh '''
                    set -eu
                    docker build -t ecommerce-frontend:${BUILD_NUMBER} services/frontend
                    docker build -t ecommerce-product-service:${BUILD_NUMBER} services/product-service
                    docker build -t ecommerce-cart-service:${BUILD_NUMBER} services/cart-service
                    docker build -t ecommerce-order-service:${BUILD_NUMBER} services/order-service
                '''
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh '''
                    set -eu
                    kubectl set image deployment/frontend \
                      frontend=ecommerce-frontend:1.0
                    kubectl set image deployment/product-service \
                      product-service=ecommerce-product-service:1.0
                    kubectl set image deployment/cart-service \
                      cart-service=ecommerce-cart-service:1.0
                    kubectl set image deployment/order-service \
                      order-service=ecommerce-order-service:1.0

                    kubectl rollout restart deployment/frontend
                    kubectl rollout restart deployment/product-service
                    kubectl rollout restart deployment/cart-service
                    kubectl rollout restart deployment/order-service

                    kubectl rollout status deployment/frontend --timeout=120s
                    kubectl rollout status deployment/product-service --timeout=120s
                    kubectl rollout status deployment/cart-service --timeout=120s
                    kubectl rollout status deployment/order-service --timeout=120s
                '''
            }
        }
    }

    post {
        success {
            echo 'CI/CD pipeline completed successfully.'
        }
        failure {
            echo 'Pipeline failed. Review the stage logs.'
        }
    }
}

