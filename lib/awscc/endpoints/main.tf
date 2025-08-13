resource "aws_security_group" "vpc_endpoint_sg" {
  name        = "endpoint-ec2-sg"
  description = "Allow TLS inbound traffic for EC2 VPC Endpoint"
  vpc_id      = var.vpc_id

  ingress {
    description = "All In"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "vpc_endpoint-sg"
  }
}

## EC2 Endpoint ##

resource "awscc_ec2_vpc_endpoint" "ec2" {
  service_name        = "com.amazonaws.${var.region}.ec2"
  vpc_id              = var.vpc_id
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.subnet_ids
  security_group_ids  = [aws_security_group.vpc_endpoint_sg.id]
  private_dns_enabled = var.private_dns_enabled

  tags = [
    for k, v in merge(
      var.tags,
      { Name = "ec2-vpc-endpoint"}
    ) : {
      key   = k
      value = v
    }
  ]


  lifecycle {
    ignore_changes = [   
      tags
    ]
  }


}

## EBS Endpoint ##
resource "awscc_ec2_vpc_endpoint" "ebs" {
  service_name        = "com.amazonaws.${var.region}.ebs"
  vpc_id              = var.vpc_id
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.subnet_ids
  security_group_ids  = [aws_security_group.vpc_endpoint_sg.id]
  private_dns_enabled = var.private_dns_enabled

  tags = [
    for k, v in merge(
      var.tags,
      { Name = "ebs-vpc-endpoint"}
    ) : {
      key   = k
      value = v
    }
  ]


  lifecycle {
    ignore_changes = [   
      tags
    ]
  }
}

## Secretsmanager Endpoint ##
resource "awscc_ec2_vpc_endpoint" "secretsmanager" {
  service_name        = "com.amazonaws.${var.region}.secretsmanager"
  vpc_id              = var.vpc_id
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.subnet_ids
  security_group_ids  = [aws_security_group.vpc_endpoint_sg.id]
  private_dns_enabled = var.private_dns_enabled

  tags = [
    for k, v in merge(
      var.tags,
      { Name = "secretsmanager-vpc-endpoint"}
    ) : {
      key   = k
      value = v
    }
  ]


  lifecycle {
    ignore_changes = [   
      tags
    ]
  }


}


## S3 Endpoint ##
resource "awscc_ec2_vpc_endpoint" "s3" {
  service_name        = "com.amazonaws.${var.region}.s3"
  vpc_id              = var.vpc_id
  vpc_endpoint_type   = "Gateway"
  route_table_ids     = var.route_table_ids
#   security_group_ids  = [aws_security_group.vpc_endpoint_sg.id]
#   private_dns_enabled = var.private_dns_enabled

  tags = [
    for k, v in merge(
      var.tags,
      { Name = "s3-vpc-endpoint"}
    ) : {
      key   = k
      value = v
    }
  ]


  lifecycle {
    ignore_changes = [   
      tags
    ]
  }


}