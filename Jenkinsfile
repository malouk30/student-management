pipeline {
    agent any

    tools {
        jdk 'JDK17'      
        maven 'Maven3'   
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/malouk30/student-management.git'
            }
        }

        stage('Build') {
            steps {
                sh 'mvn clean package'
            }
        }

        stage('Archive Artifacts') {
            steps {
                archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
            }
        }

        // Construction de l'image Docker
        stage('Build Docker Image') {
            steps {
                script {
                    // CORRECTION : Utilisez le bon nom de repository
                    dockerImage = docker.build("malouk/studentmanagement:${env.BUILD_NUMBER}")
                }
            }
        }

        // Push vers DockerHub
        stage('Push Docker Image') {
            steps {
                script {
                    // CORRECTION : Variables génériques
                    withCredentials([usernamePassword(
                        credentialsId: 'dockerhub-credentials',
                        usernameVariable: 'DOCKER_USER',
                        passwordVariable: 'DOCKER_PASS'
                    )]) {
                        sh "echo ${DOCKER_PASS} | docker login -u ${DOCKER_USER} --password-stdin"
                        dockerImage.push()
                        
                        // Tag latest
                        sh "docker tag malouk/studentmanagement:${env.BUILD_NUMBER} malouk/studentmanagement:latest"
                        sh "docker push malouk/studentmanagement:latest"
                    }
                }
            }
        }
    }

    post {
        always {
            // Nettoyage
            sh 'docker logout'
            sh 'docker image prune -f'
        }
    }
}
