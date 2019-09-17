/*
  Filename: 06-routes.tf
  Synopsis: Create the routes for the VPC
  Comments: N/A
*/


##### Tag default route table with name
resource "aws_default_route_table" "default_route_table" {
    default_route_table_id = "${ aws_vpc.vpc.default_route_table_id }"
    tags = {
        Name = "${ var.vpc_custom_name }-default-route"
        Managed-By = "Terraform"
        ProvisionDate = "${ timestamp() }"
    }
}

# Route all traffic in default route table to internet gateway
resource "aws_route" "default_route_internet_gateway" {
    route_table_id              = "${ aws_vpc.vpc.default_route_table_id }"
    destination_cidr_block      = "0.0.0.0/0"
    gateway_id                  = "${ aws_internet_gateway.internet_gateway.id }"
}
