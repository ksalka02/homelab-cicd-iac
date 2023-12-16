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
echo "###################################  fix volume article way #############################"
lsblk
df -h

file -s /dev/xvdf

mkfs -t xfs /dev/xvdf

mkdir -p /newvolume
mkdir -p /tcagent

mount /dev/xvdf /newvolume/

df -h

echo "###################################  start docker  #############################"
systemctl start docker
echo "###################################  run docker  #############################"
docker stop teamcity_server
docker remove teamcity_server
# docker logs "container name"
# chown -R 1000:1000 /newvolume
docker run --name teamcity_server -v /newvolume:/data/teamcity_server/datadir -v /newvolume:/opt/teamcity/logs -p 8111:8111 -d jetbrains/teamcity-server

docker stop teamcity_agent
docker remove teamcity_agent

rm -r /tcagent/*

instance_ip=$(ec2-metadata --public-ipv4 | awk 'NR==1{print $2}')

docker run -u 0 --name teamcity_agent -v /tcagent:/data/teamcity_agent/conf -v /var/run/docker.sock:/var/run/docker.sock -v /opt/buildagent/work:/opt/buildagent/work -v /opt/buildagent/temp:/opt/buildagent/temp -v /opt/buildagent/tools:/opt/buildagent/tools -v /opt/buildagent/plugins:/opt/buildagent/plugins -v /opt/buildagent/system:/opt/buildagent/system -e SERVER_URL="$${instance_ip}:8111" -d jetbrains/teamcity-agent

docker ps


