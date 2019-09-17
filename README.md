Concourse pipeline to deploy terraform and validate functionality
=================================================================
This repository contains bash scripts and YAML files that will assist in the configuration and deployment of an example concourse pipeline.

Dependencies
============

- Amazon Machine Image with a kernel version of 3.19+. Concourse is not compatible with kernel versions lower than 3.19. We chose to deploy this pipeline with Ubuntu 16.04, which uses kernel version 4.10. The setup scripts included in the concourse-setup Gitlab repository use the apt-get command, which will not work on RHEL instances.
- Concourse pipelines require docker-ce, docker-compose, and the fly cli to deploy. We have included a bash script called "setup.sh" that will install docker-ce version 18.09.6, docker-compose version 1.18.0, and the fli cli version 5.3.0 on an instance. 
- Recommended: use an instance type that is at least a t2.medium. 
- The EC2 instance should have an IAM role allowing it to manage AWS infrastructure.
- You will need to put a Gitlab username and access token into the terraform.yml file under the "username" and "password" fields in the "resources" section in order to clone the Gitlab repository "concourse-setup." 
- Add id_rsa and id_rsa.pub keys into the ~/.ssh/ directory of your host instance. SSH keys generated or stored locally within the instance will need to be passed into the container as a volume in order for the container to be able to use them.

Concourse Pipeline Example Module Details
=========================================

- The base docker image for this pipeline is called hashicorp/terraform:light. It comes with terraform already installed. 

Setup of Concourse Pipeline
===========================

When configuring and deploying a concourse pipeline on a new EC2 instance, the following steps should be taken.

1. Clone the Gitlab repository "concourse-setup."

2. Run the script "setup.sh" using this command:
```
$ sudo ./setup.sh
```
This setup script will download docker-ce and docker-compose onto the instance, and clone the concourse/docker Github repository. It will also start docker and add the local user (ec2-user) to the docker group. This allows the ec2-user to run docker commands without using sudo. Finally, the script downloads and installs the fly cli and target the API. When the script prompts you for an IP address, enter the public IP of the instance you are working on. 

3. Run the following commands to check that the concourse database, web, and worker subsystems are working: 
```
$ docker ps
```

4. Run the script "test.sh" using this command: 
```
$ sudo ./test.sh
```
This script deploys the pipeline configured in the terraform.yml file using commands from the fly cli. To modify the performance of this pipeline, you must modify the terraform.yml file. 


Troubleshooting Common Issues
=============================

1. If you run out of space in the var directory, specifically var/lib/docker: 
 * run the command
```
$ sudo reboot
```
 * to prune docker and make space by removing unused volumes, images, or containers, run the commands
```
$ docker volume prune
$ docker image prune
$ docker container prune
```

2. If one or more of Concourse's subsystems (database, web, or worker) don't correctly initialize when you run the command docker-compose up -d: 
 * try running the below commands until all three subsystems come up
```
$ docker-compose down
$ docker-compose up -d
```

3. If you get an error similar to "sudo: unable to resolve host ec2-user":
 * edit the file /etc/hosts and replace the line that reads "{IP-ADDRESS} kickseed" with the line "{IP-ADDRESS} ec2-user" 


