resource "awscc_ec2_subnet" "engines_priv_subnet" {
    vpc_id                  = awscc_ec2_vpc.main.id
    cidr_block              = var.engines_priv_subnet["cidr_block"]
    map_public_ip_on_launch = false
    tags = [
      {
        key   = "Name"
        value = var.engines_priv_subnet["tag"]
      }
    ]
}

resource "awscc_ec2_route_table" "engines_priv_rt" {
    vpc_id = awscc_ec2_vpc.main.id
    tags = [
      { key = "Name" 
        value = "${var.engines_priv_subnet.tag}" 
      }
    ]
}


resource "awscc_ec2_route" "engines_priv_rt_routes" {
  route_table_id              = awscc_ec2_route_table.engines_priv_rt.id
  destination_cidr_block      = "0.0.0.0/0"  
  nat_gateway_id              = awscc_ec2_nat_gateway.nat_gw.id
}

resource "awscc_ec2_subnet_route_table_association" "engines_priv_rta" {
    count = var.engines_priv_subnet["internet"] == "enabled" ? 1 : 0
    subnet_id      = awscc_ec2_subnet.engines_priv_subnet.id
    route_table_id = awscc_ec2_route_table.engines_priv_rt.id
}