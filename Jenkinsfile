pipeline {
    agent { label 'docker-agent' } // Instructs Jenkins to run exclusively on your ci-agent machine

    environment {
        DOCKER_REGISTRY = "281644" // <-- CHANGE THIS to your actual Docker Hub username
        IMAGE_NAME      = "prt-web"
        IMAGE_TAG       = "latest"
        DOCKER_CRED_ID  = "dockerhub"  // Matches Jenkins Credentials ID for Docker Hub
        KUBE_CONFIG_ID  = "k8s-config-file"         // Matches Jenkins Credentials ID for Secret file
    }

    stages {
        stage('Checkout Source') {
            steps {
                // Pulls all files (Dockerfile, YAMLs, Terraform files) into agent workspace
                checkout scm
            }
        }

        stage('Docker Build & Push') {
            steps {
                script {
                    // Securely bind Docker Hub password credentials
                    withCredentials([usernamePassword(credentialsId: env.DOCKER_CRED_ID, usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                        sh "echo \$PASS | docker login -u \$USER --password-stdin"
                        
                        // Build and tag image
                        sh "docker build -t ${DOCKER_REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG} ."
                        
                        // Push the final image to Docker Hub
                        sh "docker push ${DOCKER_REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG}"
                    }
                }
            }
        }


        stage('Deploy to Kubernetes') {
            steps {
                script {
                    // Dynamically injects the kubeconfig credential file temporarily to authenticate with k8s-node
                    withCredentials([file(credentialsId: env.KUBE_CONFIG_ID, variable :'KUBECONFIG')]) {
                        sh "kubectl --kubeconfig=\$KUBECONFIG apply -f deployment.yaml"
                        sh "kubectl --kubeconfig=\$KUBECONFIG apply -f service.yaml"
                        
                        // Force Kubernetes to pull down the newly pushed image even if the tag remains 'latest'
                        sh "kubectl --kubeconfig=\$KUBECONFIG rollout restart deployment/prt-app-deployment"
                    }
                }
            }
        }
    }

    post {
        always {
            // Housekeeping: wipe credentials logs from the local agent
            sh "docker logout || true"
        }
    }
}
