/*
  Filename: 00-dependencies.tf
  Synopsis: Backend settings required to setup VPC
  Description: Declaration of providers and variables

*/

##### Providers
# AWS authentication information input through terraform.tfvars file
provider "aws" {
    access_key		= "${ var.access_key }"
    secret_key		= "${ var.secret_key }"
    region		= "${ var.aws_region }"
}


##### Local Variables
# Defined IP address range for VPC
locals {
    vpc_cidr_block = "${ var.vpc_custom_octet }.0.0/16"
}
