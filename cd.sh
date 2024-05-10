#!/bin/bash
echo "running deployment.sh" >> /home/ubuntu/cicd/cicd.log
commit_url=$(cat /home/ubuntu/cicd/config.json | jq '.git_url'| tr -d '"')
commit_branch=`cat /home/ubuntu/cicd/config.json | jq '.git_branch'| tr -d '"'` 
#echo $commit_url $commit_branch
git clone $commit_url /var/www/html/simple-blog
cd /var/www/html/simple-blog
git checkout $commit_branch
cp /var/www/html/simple-blog/index.html  /var/www/html/
systemctl restart nginx 
rm -rf  /var/www/html/simple-blog/

