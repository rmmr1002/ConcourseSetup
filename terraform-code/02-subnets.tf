/*
  Filename: 02-subnets.tf
  Synopsis: Creates the VPC subnets
  Description: Creates basic subnets in availability zones a and b
  Comments: N/A
*/


# Subnet for static infrastructure
resource "aws_subnet" "subnet_1a" {
    vpc_id            = "${ aws_vpc.vpc.id }"
    availability_zone = "${ var.aws_region }a"
    cidr_block        = "${var.vpc_custom_octet }.16.0/24"
    map_public_ip_on_launch = "false"
    tags = {
        Name = "${ var.vpc_custom_name }-az1a-subnet"
        Managed-By = "Terraform"
        ProvisionDate = "${ timestamp() }"
    }
}


# Subnet for externally facing machines
resource "aws_subnet" "subnet_1b" {
    vpc_id            = "${ aws_vpc.vpc.id }"
    availability_zone = "${ var.aws_region }b"
    cidr_block        = "${ var.vpc_custom_octet }.32.0/24"
    map_public_ip_on_launch = "false"
    tags = {
        Name = "${ var.vpc_custom_name }-az1b-subnet"
        Managed-By = "Terraform"
        ProvisionDate = "${ timestamp() }"
    }
}
