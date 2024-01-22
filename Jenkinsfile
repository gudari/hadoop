pipeline {
    agent {
        kubernetes {
            yaml """
kind: Pod
metadata:
  name: default
spec:
  containers:
  - name: jnlp
    image: gudari/jenkins-agent:3206.vb_15dcf73f6a_9-3-jdk11-hadoop-arm64
    imagePullPolicy: Always
"""
        }
    }
    environment {
        GITHUB_ORGANIZATION = 'gudari'
        GITHUB_REPO         = 'hadoop'
        VERSION             = '2.10.2'
        GITHUB_TOKEN        = credentials('github_token')
    }
    stages {
        stage('Build') {
            steps {
                sh ("mvn -Dmaven.repo.local=${HOME}/.m2/repository package -Pdist,yarn-ui -DskipTests -Dtar -Pnative -Drequire.snappy -Drequire.openssl -Drequire.fuse")

                sh ("./create_release.sh $GITHUB_ORGANIZATION $GITHUB_REPO $VERSION $GITHUB_TOKEN")
            }
        }
    }
}
