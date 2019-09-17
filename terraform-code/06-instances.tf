/*
  Filename: 08-instances.tf
  Synopsis: Spin up VPC Instances
*/


##### Spin up instances only if conditional flag (var.instances) is set to true. Default is false.


##### Find the latest RHEL 7.6 Base image
data "aws_ami" "rhel7_6" {
    most_recent = true
    filter {
        name = "name"
        values = [""]
    }
    owners = [""] 
}


##### Sample Instance
resource "aws_instance""instance-1-RHEL7_6" {
    count = "${ var.aws_instances ? 1 : 0 }"
    ami = "${ data.aws_ami.rhel7_6.image_id }"
    instance_type = "t2.micro"
    tags = {
        Name = "${ var.vpc_custom_name }-RHEL7_6-Jumpbox-1"
        Managed-By = "Terraform"
        ProvisionDate = "${ timestamp() }"
       
    }
    subnet_id = "${ aws_subnet.subnet_1a.id }"
    key_name = "${ var.aws_keypair ? aws_key_pair.key_pair[count.index].key_name : var.existing_aws_keypair_name }"
    associate_public_ip_address = true
}
