pipeline {
    agent { docker { image 'golang' } }
    stages {
        stage('version') {
            steps {
                sh 'go version'
            }
        }
            stage('build') {
                steps {
                 sh 'go build'
               }
           }
      }
} 
