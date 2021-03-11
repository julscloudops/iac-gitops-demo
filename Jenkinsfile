pipeline {
    agent { docker { image 'golang' } }
    stages {
        stage('Testing') {
            steps {
                sh 'go version'
                
            }
        }
        
        stage('Build') {
            steps {
               sh 'go build'
            }
        }
    }
}
