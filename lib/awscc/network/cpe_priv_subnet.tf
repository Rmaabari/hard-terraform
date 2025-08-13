resource "aws_subnet" "cpe_priv_subnet" {
    count                   = length(var.cpe_priv_subnet) == 0 ? 0 : 1
    vpc_id                  = awscc_ec2_vpc.main.id
    cidr_block              = var.cpe_priv_subnet["cidr_block"]
    map_public_ip_on_launch = false
    tags                    = { Name = var.cpe_priv_subnet["tag"] }
}

resource "aws_route_table" "cpe_priv_rt" {
    count = length(var.cpe_priv_subnet) == 0 ? 0 : 1
    vpc_id = awscc_ec2_vpc.main.id
    tags = { Name = var.cpe_priv_subnet["tag"] }
}

data "aws_instance" "selected" {
  count = length(var.cpe_priv_subnet) == 0 ? 0 : 1
  instance_id = var.cpe_priv_subnet["dg_instance_id"]
}


resource "aws_route" "cpe_priv_route" {
  count                  = length(var.cpe_priv_subnet) == 0 ? 0 : 1
  route_table_id         = aws_route_table.cpe_priv_rt[0].id
  destination_cidr_block = "0.0.0.0/0"
  network_interface_id   = data.aws_instance.selected[0].network_interface_id
}


resource "aws_route_table_association" "cpe_priv_rta" {
    count          = length(var.cpe_priv_subnet) == 0 ? 0 : 1
    subnet_id      = element(aws_subnet.cpe_priv_subnet.*.id, 0)
    route_table_id = aws_route_table.cpe_priv_rt[0].id
}