pipeline {
    agent { docker { image 'golang' } }
    stages {
        stage('build') {
            steps {
                sh 'go version'
                echo "Building the application..."
            }
        }
    }
}
