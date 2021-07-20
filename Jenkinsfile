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
    image: gudari/jenkins-agent:4.9-hadoop-arm64-21.07.08
    imagePullPolicy: Always
"""
        }
    }
    environment {
        GITHUB_ORGANIZATION = 'gudari'
        GITHUB_REPO         = 'hadoop'
        GITHUB_TOKEN        = credentials('github_token')
    }
    stages {
        stage('Build') {
            steps {
                sh ("mvn -Dmaven.repo.local=${HOME}/.m2/repository package -Pdist,yarn-ui -DskipTests -Dtar -Pnative -Drequire.snappy -Drequire.openssl -Drequire.fuse")

                sh '''#!/bin/bash

GITHUB_API=https://api.github.com
RELEASE_BRANCH=$(git branch | sed -n '/\* /s///p')
VERSION=$(echo $release | sed 's/.*\([0-9]\.[0-9]\.[0-9]\).*/\1/')


release=$(curl -XPOST -H "Authorization:token $GITHUB_TOKEN" \
    --data "{\"tag_name\": \"$RELEASE_BRANCH\", \"target_commitish\": \"$RELEASE_BRANCH\", \"name\": \"$RELEASE_BRANCH\", \"draft\": false }" \
    $GITHUB_API/repos/$GITHUB_ORGANIZATION/$GITHUB_REPO/releases)

curl -XPOST -H "Authorization:token $GITHUB_TOKEN" \
    -H "Content-Type:application/octet-stream" \
    --upload-file hadoop-dist/target/hadoop-$VERSION.tar.gz $GITHUB_API/repos/$GITHUB_ORGANIZATION/$GITHUB_REPO/releases/$id/assets?name=hadoop-$VERSION.tar.gz
                '''
            }
        }
    }
}