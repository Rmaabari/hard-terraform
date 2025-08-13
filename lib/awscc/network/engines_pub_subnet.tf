# 1) create your subnet (you already have this)
resource "awscc_ec2_subnet" "engines_pub_subnet" {
  vpc_id                  = awscc_ec2_vpc.main.id
  cidr_block              = var.engines_pub_subnet["cidr_block"]
  map_public_ip_on_launch = true
  tags = [{ key = "Name", value = var.engines_pub_subnet["tag"] }]
}

# 2) create a CC route table (no nested "route" block here):
resource "awscc_ec2_route_table" "engines_rt" {
  vpc_id = awscc_ec2_vpc.main.id
  tags = [
    { key = "Name", value = "${var.engines_pub_subnet.tag}-rt" },
  ]
}

# 3) one awscc_ec2_route per route
resource "awscc_ec2_route" "internet" {
  route_table_id         = awscc_ec2_route_table.engines_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = awscc_ec2_internet_gateway.gw.id
  # make sure the IGW is fully Attached to the VPC first
  depends_on = [
    awscc_ec2_vpc_gateway_attachment.gw_attachment,
  ]
}


# 4) associate your subnet to that table
resource "awscc_ec2_subnet_route_table_association" "engines_rta" {
  count          = var.engines_pub_subnet["internet"] == "enabled" ? 1 : 0
  subnet_id      = awscc_ec2_subnet.engines_pub_subnet.id
  route_table_id = awscc_ec2_route_table.engines_rt.id
}