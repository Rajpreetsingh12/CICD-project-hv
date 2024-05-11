#!/bin/bash

date=$(date '+%Y-%m-%d %H:%M:%S')

SCRIPT=$(readlink -f "$0")

# Get the directory of the script
rootfolder=$(dirname "$SCRIPT")
projectfolder="$rootfolder/project"
deployment_log="$rootfolder/deployment.log"

if [ ! -d "$projectfolder" ]; then
    mkdir -p "$projectfolder"
fi

echo "$date - Deploying the latest release" >> "$deployment_log"

if ! [ -x "$(command -v jq)" ]; then
    echo 'Error: jq is not installed. Installing jq to run this script' >&2
    sudo apt-get install jq -y
fi

commit_url=$(jq -r '.git_url' "$rootfolder/config.json")
commit_branch=$(jq -r '.git_branch' "$rootfolder/config.json")

git clone "$commit_url" "$projectfolder/latest_version"
cd "$projectfolder/latest_version"
git checkout "$commit_branch"

cp "$projectfolder/latest_version/index.html" /var/www/html/

systemctl restart nginx 

version=$(date '+%Y%m%d%H%M%S')
mv "$projectfolder/latest_version" "$rootfolder/version_$version"
