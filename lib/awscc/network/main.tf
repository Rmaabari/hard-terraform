resource "awscc_ec2_vpc" "main" {
  cidr_block            = var.cidr_vpc_block
  enable_dns_hostnames  = var.enable_vpc_dnsnames
  tags = [
    for key, value in var.vpc_tags : {
      key   = key
      value = value
    }
  ]

  lifecycle {
    ignore_changes = [   
      tags
    ]
  }
  
}

resource "awscc_ec2_internet_gateway" "gw" {
    tags = [
        for key, value in var.vpc_tags : {
        key   = key
        value = value
        }
    ]
}

resource "awscc_ec2_vpc_gateway_attachment" "gw_attachment" {
  vpc_id             = awscc_ec2_vpc.main.id
  internet_gateway_id = awscc_ec2_internet_gateway.gw.id
}

resource "aws_eip" "nat_eip" {
    tags       = { Name = "${var.core_priv_subnet["tag"]}-nat-eip", "label" = "internet",  "resource" = "temp" }
}

resource "awscc_ec2_nat_gateway" "nat_gw" {
    allocation_id = aws_eip.nat_eip.id
    subnet_id     = awscc_ec2_subnet.entry_pub_subnet.id
    tags       = [
      { key = "Name", value = "${var.core_priv_subnet["tag"]}-nat-inet" }, 
      { key = "label", value = "internet" },  
      { key = "resource", value = "temp" },
    ]

  lifecycle {
    ignore_changes = [   
      tags
    ]
  }

}