#!/bin/bash

#Synposis: Installs docker-ce, docker-compose, the fli cli, and clones the Github repository "concourse-docker" 
#Modified: 20190621

#Install Docker
sudo apt-get install apt-transport-https
sudo apt-get update
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
sudo apt-cache policy docker-ce
sudo apt-get install -y docker-ce
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker ec2-user

#Install Docker-Compose
sudo curl -L https://github.com/docker/compose/releases/download/1.18.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
docker-compose --version

#Clone Concourse-Docker repo
git clone https://github.com/concourse/concourse-docker.git

#Request IP address from user 
echo -e "Enter EC2 Public IP Address: \c"
read ip

sudo sed -i "s|CONCOURSE_EXTERNAL_URL: .*|CONCOURSE_EXTERNAL_URL: http://${ip}:8080|" /home/ec2-user/concourse-setup/concourse-docker/docker-compose.yml

sudo sed -i 's|volumes: .*|volumes: ["./keys/worker:/concourse-keys", "/home/ec2-user/.ssh/id_rsa.pub:/root/.ssh/id_rsa.pub", "/home/ec2-user/.ssh/id_rsa:/root/.ssh/id_rsa"]|2' /home/ec2-user/concourse-setup/concourse-docker/docker-compose.yml

#Generate keys
sudo ./concourse-docker/keys/generate

#Start the docker daemon
sudo systemctl start docker
sudo systemctl enable docker

#Start the web, worker, and database
cd concourse-docker
sudo dockerd
sudo docker-compose up -d

#Curl fly binary and move it to usr/bin
curl -o fly "http://${ip}:8080/api/v1/cli?arch=amd64&platform=linux"
sudo chmod +x fly
mv fly /usr/bin/

#Check if the web, worker, and database are up
sudo docker ps

sudo fly --target tutorial login --concourse-url http://${ip}:8080 -u test -p test
sudo fly --target tutorial sync