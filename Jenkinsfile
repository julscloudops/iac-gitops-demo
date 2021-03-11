pipeline {
    agent { docker { image 'golang' } }
    stages {
        stage('Version') {
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
