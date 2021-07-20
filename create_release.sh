#!/bin/bash

GITHUB_ORGANIZATION=$1
GITHUB_REPO=$2
GITHUB_TOKEN=$3

echo "Exporting token and enterprise api to enable github-release tool"
GITHUB_API=https://api.github.com
RELEASE_BRANCH=$(git branch | sed -n '/\* /s///p')
VERSION=$(echo $RELEASE_BRANCH | sed 's/.*\([0-9]\.[0-9]\.[0-9]\).*/\1/')


release=$(curl -XPOST -H "Authorization:token $GITHUB_TOKEN" \
    --data "{\"tag_name\": \"$RELEASE_BRANCH\", \"target_commitish\": \"$RELEASE_BRANCH\", \"name\": \"$RELEASE_BRANCH\", \"draft\": false }" \
    $GITHUB_API/repos/$GITHUB_ORGANIZATION/$GITHUB_REPO/releases)

id=$(echo "$release" | sed -n -e 's/"id":\ \([0-9]\+\),/\1/p' | head -n 1 | sed 's/[[:blank:]]//g')

curl -XPOST -H "Authorization:token $GITHUB_TOKEN" \
    -H "Content-Type:application/octet-stream" \
    --upload-file hadoop-dist/target/hadoop-$VERSION.tar.gz $GITHUB_API/repos/$GITHUB_ORGANIZATION/$GITHUB_REPO/releases/$id/assets?name=hadoop-$VERSION.tar.gz
