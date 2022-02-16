pipeline {
    agent {
        kubernetes {
            yaml '''
            apiVersion: v1
            kind: Pod
            metadata:
            labels:
              app: app
            spec:
              containers:
              - name: ubuntu
                  image: amjedsaleel/docker
                  command:
                  - cat
                  tty: true
            '''
        }
    }
    stages {
        stage('Pull the code') {
            steps {
                git branch: 'main', url: 'https://github.com/amjedsaleel/django-hello.git'
            }
        }
        stage('Static code analysis') {
            steps {
                script {
                    def scannerHome = tool 'sonarQubeScanner'
                    withSonarQubeEnv('SonarQube') {
                     sh "${scannerHome}/bin/sonar-scanner"
                    }
                }
            }
        }
        stage('Quality gate') {
            steps {
                timeout(time: 1, unit: 'HOURS') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }
        stage('Docker build') {
            steps {
                sh 'docker build -t django-hello .'
            }
        }
        stage('Tag docker image') {
            steps {
                sh 'docker tag django-hello amjedsaleel/django-hello:$BUILD_NUMBER'
            }
        }
        stage('Push to docker hub') {
            steps {
                withCredentials([string(credentialsId: '121b8ad1-a72d-41d1-9567-f2a4a65dc5b4', variable: 'DOCKER_HUB_PASSWORD')]) {
                    sh 'docker login -u amjedsaleel -p $DOCKER_HUB_PASSWORD'
                }
                sh 'docker push amjedsaleel/django-hello:$BUILD_NUMBER'
                sh 'docker logout'
            }
        }
        stage('Deploy') {
            steps {
                build job: 'django hello deploy', parameters: [string(name: 'JOB', value: "${BUILD_NUMBER}")] 
            }
        }        
    }
}
