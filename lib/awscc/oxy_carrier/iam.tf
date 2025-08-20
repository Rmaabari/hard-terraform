# 1. Build the assume‐role document (classic AWS provider, unchanged)
data "aws_iam_policy_document" "assume_policy_document" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

# 2. Carrier-EFS Role (AWSCC provider)
resource "awscc_iam_role" "carrier_efs" {
  role_name                   = "role-${var.lab_name}-oxy-carrier-efs"
  path                        = "/"
  assume_role_policy_document = data.aws_iam_policy_document.assume_policy_document.json

  # attach the managed policy you’ll create below
  managed_policy_arns = [
    aws_iam_policy.carrier_efs.arn
  ]

  # convert your var.tags + Name into the AWSCC “list of {key,value}” format
  tags = [
    for k in sort(keys(
      merge(
        var.tags,
        { Name = "${var.lab_name}-oxy-carrier-efs" }
      )
    )) : {
      key   = k
      value = merge(
        var.tags,
        { Name = "${var.lab_name}-oxy-carrier-efs" }
      )[k]
    }
  ]

  lifecycle {
    ignore_changes = [
      assume_role_policy_document,
      managed_policy_arns,
      tags,
    ]
  }
}

# 3. Carrier-EFS Permissions Policy (classic AWS provider, unchanged)
data "aws_iam_policy_document" "carrier_efs_document" {
  statement {
    actions = [
      "elasticfilesystem:ClientMount",
      "elasticfilesystem:ClientWrite",
      "elasticfilesystem:ClientRootAccess"
    ]
    effect    = "Allow"
    resources = ["*"]
  }
}

resource "aws_iam_policy" "carrier_efs" {
  name   = "policy-${var.lab_name}-oxy-carrier-efs"
  policy = data.aws_iam_policy_document.carrier_efs_document.json
  tags   = merge(var.tags, { Name = "${var.lab_name}-oxy-carrier-efs" })
}

# 4. Carrier-EFS Instance Profile (AWSCC provider)
resource "awscc_iam_instance_profile" "carrier_efs" {
  instance_profile_name = "${var.lab_name}-oxy-carrier-efs-profile"
  roles                 = [
    awscc_iam_role.carrier_efs.role_name
  ]
}
