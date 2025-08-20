# -----------------------------------------------------------------------------
# 1. Assume-role policy for EC2
# -----------------------------------------------------------------------------
data "aws_iam_policy_document" "assume_policy_document" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

# -----------------------------------------------------------------------------
# 2. The Engines EC2 Role (awscc provider)
# -----------------------------------------------------------------------------
resource "awscc_iam_role" "engines_role" {
  role_name                   = var.role_name
  assume_role_policy_document = data.aws_iam_policy_document.assume_policy_document.json

  # Sorted list of tags so AWSCC & Terraform never disagree on order
  tags = [
    for k in sort(keys(
      merge(
        var.tags,
        { Name = "${var.lab_name}-engines-ec2" }
      )
    )) : {
      key   = k
      value = merge(
        var.tags,
        { Name = "${var.lab_name}-engines-ec2" }
      )[k]
    }
  ]

  lifecycle {
    ignore_changes = [
      assume_role_policy_document,
      permissions_boundary,
      policies,
      tags,
    ]
  }
}

# -----------------------------------------------------------------------------
# 3. Custom Policy Document
# -----------------------------------------------------------------------------
data "aws_iam_policy_document" "aws_ec2_engines_document" {
  statement {
    actions   = ["ec2:DeregisterImage"]
    effect    = "Allow"
    resources = ["*"]
    condition {
      test     = "StringEquals"
      variable = "ec2:ResourceTag/lab"
      values   = [var.lab_name]
    }
  }
  statement {
    actions   = ["ec2:DescribeImages", "ec2:CreateImage", "ec2:CreateTags"]
    effect    = "Allow"
    resources = ["*"]
  }
}

# -----------------------------------------------------------------------------
# 4. Attach that policy (aws provider)
# -----------------------------------------------------------------------------
resource "aws_iam_policy" "aws_ec2_engines" {
  name   = "policy-${var.lab_name}-engines-ec2"
  policy = data.aws_iam_policy_document.aws_ec2_engines_document.json

  # Classic AWS tags must be a map<string,string>
  tags = merge(
    var.tags,
    { Name = "${var.lab_name}-engines-ec2" }
  )
}

resource "aws_iam_role_policy_attachment" "aws_ec2_engines" {
  role       = awscc_iam_role.engines_role.role_name
  policy_arn = aws_iam_policy.aws_ec2_engines.arn
}

# -----------------------------------------------------------------------------
# 5. EC2 Instance Profile
# -----------------------------------------------------------------------------
resource "aws_iam_instance_profile" "engines_instance_profile" {
  name = var.profile_name
  role = awscc_iam_role.engines_role.role_name
}



# data "aws_iam_policy_document" "assume_policy_document" {
#   statement {
#     actions = [
#       "sts:AssumeRole"
#     ]
#     principals {
#       type        = "Service"
#       identifiers = ["ec2.amazonaws.com"]
#     }
#   }
# }

# resource "awscc_iam_role" "engines_role" {
#   role_name = var.role_name
#   assume_role_policy_document = data.aws_iam_policy_document.assume_policy_document.json
#   tags = [
#     for k, v in merge(var.tags, { Name = "${var.lab_name}-engines-ec2" }) :
#     { key = k, value = v }
#   ]
# }

# data "aws_iam_policy_document" "aws_ec2_engines_document" {
#   statement {
#     actions = [
#         "ec2:DeregisterImage"
#     ]
#     effect = "Allow"
#     resources = [ "*" ]
#     condition {
#       test     = "StringEquals"
#       variable = "ec2:ResourceTag/lab"
#       values   = [var.lab_name]
#     }
#   }
#   statement {
#     actions = [
#         "ec2:DescribeImages",
#         "ec2:CreateImage",
#         "ec2:CreateTags" 
#     ]
#     effect = "Allow"
#     resources = [ "*" ]
#   }
# }

# resource "aws_iam_policy" "aws_ec2_engines" {
#   name   = "policy-${var.lab_name}-engines-ec2"
#   policy = data.aws_iam_policy_document.aws_ec2_engines_document.json
#   tags = merge(var.tags, {Name = "${var.lab_name}-engines-ec2"})
# }

# resource "aws_iam_role_policy_attachment" "aws_ec2_engines" {
#   policy_arn = aws_iam_policy.aws_ec2_engines.arn
#   role       = awscc_iam_role.engines_role.role_name
# }


# resource "aws_iam_instance_profile" "engines_instance_profile" {
#   name = var.profile_name
#   role = awscc_iam_role.engines_role.role_name
# }
