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
yum -y update

echo "###################################  install docker  #############################"
yum -y install docker

echo "###################################  start docker  #############################"
systemctl start docker

echo "###################################  ECR AUTH #############################"
docker login -u AWS -p $(aws ecr get-login-password --region us-east-1) 939365853055.dkr.ecr.us-east-1.amazonaws.com/players-api

echo "###################################  PULL docker image  #############################"
docker pull 939365853055.dkr.ecr.us-east-1.amazonaws.com/players-api:latest


echo "###################################  RUN docker  #############################"
export PORT="${port}"
docker run --name playersapicontainer -e PORT -p ${port}:${port} 939365853055.dkr.ecr.us-east-1.amazonaws.com/players-api

docker ps
