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

# resource "aws_iam_role" "control_efs" {
#   name                 = "role-${var.lab_name}-control-host-efs"
#   path                 = "/"
#   assume_role_policy   = data.aws_iam_policy_document.assume_policy_document.json
#   tags = merge(var.tags, {Name = "${var.lab_name}-control-host-efs"})
# }

# data "aws_iam_policy_document" "control_efs_document" {
#   statement {
#     actions = [
#         "elasticfilesystem:ClientMount",
#         "elasticfilesystem:ClientWrite",
#         "elasticfilesystem:ClientRootAccess"   
#     ]
#     effect = "Allow"
#     resources = [ "*" ]
#   }
# }

# resource "aws_iam_policy" "control_efs" {
#   name   = "policy-${var.lab_name}-control-host-efs"
#   policy = data.aws_iam_policy_document.control_efs_document.json
#   tags = merge(var.tags, {Name = "${var.lab_name}-control-host-efs"})
# }

# resource "aws_iam_role_policy_attachment" "control_efs" {
#   policy_arn = aws_iam_policy.control_efs.arn
#   role       = aws_iam_role.control_efs.name
# }

# resource "aws_iam_instance_profile" "control_efs" {
#   role = aws_iam_role.control_efs.name
#   path = "/"
# }