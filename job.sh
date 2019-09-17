#!/bin/sh

#Change to working directory with .tf files cloned from repo
cd concourse-resource/terraform-code/

#Terraform build cycle
terraform init -lock=false
terraform plan -lock=false 
terraform validate
terraform init
terraform apply -auto-approve -lock=false
terraform destroy -auto-approve
