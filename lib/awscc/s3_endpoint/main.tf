data "aws_region" "current" {}

resource "awscc_ec2_vpc_endpoint" "s3" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${data.aws_region.current.name}.s3"
  vpc_endpoint_type = "Gateway"

  # awscc will automatically create the prefix-list → vpce route entries
  route_table_ids   = var.route_table_ids

  # transform your map(string) into a List<Tag> block
  tags = [
    for k, v in var.tags : {
      key   = k
      value = v
    }
  ]
}