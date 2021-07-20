
#!/bin/bash

GITHUB_ORGANIZATION=$1
GITHUB_REPO=$2
VERSION=$3
GITHUB_TOKEN=$4

echo "Exporting token and enterprise api to enable github-release tool"
GITHUB_API=https://api.github.com
RELEASE_NAME="release-${VERSION}-arm64"


release=$(curl -XPOST -H "Authorization:token $GITHUB_TOKEN" \
    --data "{\"tag_name\": \"$RELEASE_NAME\", \"target_commitish\": \"$RELEASE_NAME\", \"name\": \"$RELEASE_NAME\", \"draft\": false }" \
    $GITHUB_API/repos/$GITHUB_ORGANIZATION/$GITHUB_REPO/releases)

id=$(echo "$release" | sed -n -e 's/"id":\ \([0-9]\+\),/\1/p' | head -n 1 | sed 's/[[:blank:]]//g')

curl -XPOST -H "Authorization:token $GITHUB_TOKEN" \
    -H "Content-Type:application/octet-stream" \
    --upload-file hadoop-dist/target/hadoop-$VERSION.tar.gz $GITHUB_API/repos/$GITHUB_ORGANIZATION/$GITHUB_REPO/releases/$id/assets?name=hadoop-$VERSION.tar.gz
    