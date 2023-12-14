Content-Type: multipart/mixed; boundary="//"
MIME-Version: 1.0

--//
Content-Type: text/cloud-config; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="cloud-config.txt"

#cloud-config
cloud_final_modules:
- [scripts-user, always]

--//
Content-Type: text/x-shellscript; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="userdata.txt"
#!/bin/bash

# yum -y update
# echo "###################################  install git  #############################"
# yum -y install git
# echo "###################################  install pip  #############################"
# yum -y install python3-pip
# echo "###################################  clone repo  #############################"
# git clone https://github.com/ksalka02/api001.git
# echo "###################################  UPDATE repo  #############################"
# git pull

# cd api001/mongo

# echo "###################################  install requirements  #############################"
# pip install -r requirements.txt
# echo "###################################  run playersdb.py  #############################"

yum -y update

echo "###################################  install docker  #############################"
yum -y install docker

echo "###################################  start docker  #############################"
systemctl start docker

echo "###################################  ECR AUTH #############################"
docker login -u AWS -p $(aws ecr get-login-password --region us-east-1) 939365853055.dkr.ecr.us-east-1.amazonaws.com/players-api

echo "###################################  PULL docker image  #############################"
docker pull 939365853055.dkr.ecr.us-east-1.amazonaws.com/players-api:latest

# export PORT="${port}"

echo "###################################  RUN docker  #############################"
# docker run --name playerapicontainer -p 5000:5000 players-api
# docker run --name playerapicontainer -p $${ENV}:5000 players-api
docker run --name playerapicontainer -p "${port}":5000 players-api
export PORT="${port}"
# "$${instance_ip}:8111"

docker ps
