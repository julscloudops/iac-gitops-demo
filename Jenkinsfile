pipeline {
    agent none 
    stages {
        stage('Build') { 
            agent {
                docker {
                    image 'golang' 
                }
            }
            steps {
                sh 'go build' 
                
            }
        }
    }
}
