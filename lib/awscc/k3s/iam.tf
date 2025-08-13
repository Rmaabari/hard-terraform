# -----------------------------------------------------------------------------
# 1. Assume-role policies for EC2 and EBS CSI
# -----------------------------------------------------------------------------
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

data "aws_iam_policy_document" "ebs_csi_assume" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

# -----------------------------------------------------------------------------
# 2. EBS CSI Role (awscc provider)
# -----------------------------------------------------------------------------
resource "awscc_iam_role" "ebs_csi_role" {
  role_name                   = "role-${var.lab_name}-${var.cluster_name}-ebs-csi"
  path                        = "/"
  assume_role_policy_document = data.aws_iam_policy_document.ebs_csi_assume.json
  managed_policy_arns         = [ aws_iam_policy.aws_ebs_csi.arn ]

  # Sorted list-of-objects tags
  tags = [
    for k in sort(keys(
      merge(
        var.tags,
        { Name = "role-${var.lab_name}-${var.cluster_name}-ebs-csi" }
      )
    )) : {
      key   = k
      value = merge(
        var.tags,
        { Name = "role-${var.lab_name}-${var.cluster_name}-ebs-csi" }
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

# -----------------------------------------------------------------------------
# 3. EBS CSI Permissions Policy
# -----------------------------------------------------------------------------
data "aws_iam_policy_document" "aws_ebs_csi_document" {
  statement {
    actions = [
      "ec2:AttachVolume",
      "ec2:CreateSnapshot",
      "ec2:CreateTags",
      "ec2:CreateVolume",
      "ec2:DeleteSnapshot",
      "ec2:DeleteTags",
      "ec2:DeleteVolume",
      "ec2:DescribeAvailabilityZones",
      "ec2:DescribeInstances",
      "ec2:DescribeSnapshots",
      "ec2:DescribeTags",
      "ec2:DescribeVolumes",
      "ec2:DescribeVolumesModifications",
      "ec2:DetachVolume",
      "ec2:ModifyVolume",
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret",
      "secretsmanager:ListSecrets"
    ]
    effect    = "Allow"
    resources = ["*"]
  }
}

# -----------------------------------------------------------------------------
# 4. Attach the EBS CSI policy (aws provider)
# -----------------------------------------------------------------------------
resource "aws_iam_policy" "aws_ebs_csi" {
  name   = "policy-${var.lab_name}-${var.cluster_name}-ebs-csi"
  policy = data.aws_iam_policy_document.aws_ebs_csi_document.json

  # Classic AWS provider tags as a map<string,string>
  tags = merge(
    var.tags,
    { Name = "${var.lab_name}-${var.cluster_name}-ebs-csi" }
  )
}

# -----------------------------------------------------------------------------
# 5. EBS CSI Instance Profile
# -----------------------------------------------------------------------------
resource "awscc_iam_instance_profile" "aws_ebs_csi" {
  instance_profile_name = "${var.lab_name}-${var.cluster_name}-ebs-csi-profile"
  roles                 = [ awscc_iam_role.ebs_csi_role.role_name ]
}



# data "aws_iam_policy_document" "assume_policy_document" {
#   statement {
#     effect = "Allow"
#     principals {
#       type        = "Service"
#       identifiers = ["ec2.amazonaws.com"]
#     }
#     actions = ["sts:AssumeRole"]
#   }
# }


# data "aws_iam_policy_document" "ebs_csi_assume" {
#   statement {
#     effect = "Allow"
#     principals {
#       type        = "Service"
#       identifiers = ["ec2.amazonaws.com"]
#     }
#     actions = ["sts:AssumeRole"]
#   }
# }

# resource "awscc_iam_role" "ebs_csi_role" {
#   role_name                   = "role-${var.lab_name}-${var.cluster_name}-ebs-csi"
#   path                        = "/"
#   assume_role_policy_document = data.aws_iam_policy_document.ebs_csi_assume.json
#   managed_policy_arns = [ aws_iam_policy.aws_ebs_csi.arn ]
# }

# data "aws_iam_policy_document" "aws_ebs_csi_document" {
#   statement {
#     actions = [
#         "ec2:AttachVolume",
#         "ec2:CreateSnapshot",
#         "ec2:CreateTags",
#         "ec2:CreateVolume",
#         "ec2:DeleteSnapshot",
#         "ec2:DeleteTags",
#         "ec2:DeleteVolume",
#         "ec2:DescribeAvailabilityZones",
#         "ec2:DescribeInstances",
#         "ec2:DescribeSnapshots",
#         "ec2:DescribeTags",
#         "ec2:DescribeVolumes",
#         "ec2:DescribeVolumesModifications",
#         "ec2:DetachVolume",
#         "ec2:ModifyVolume",
#         "secretsmanager:GetSecretValue",
#         "secretsmanager:DescribeSecret",
#         "secretsmanager:ListSecrets"
#     ]
#     effect = "Allow"
#     resources = [ "*" ]
#   }
# }

# resource "aws_iam_policy" "aws_ebs_csi" {
#   name   = "policy-${var.lab_name}-${var.cluster_name}-ebs-csi"
#   policy = data.aws_iam_policy_document.aws_ebs_csi_document.json
#   tags = merge(local.tags, {Name = "${var.lab_name}-${var.cluster_name}-ebs-csi"})
# }


# resource "awscc_iam_instance_profile" "aws_ebs_csi" {
#   instance_profile_name = "${var.lab_name}-${var.cluster_name}-ebs-csi-profile"
#   roles                 = [ awscc_iam_role.ebs_csi_role.role_name ]
# }