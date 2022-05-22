# data "aws_security_groups" "container_sgp" {
#   filter {
#     name = "tag:Name"
#     values = ["${var.service}-container*"]
#   }
# }

# output "container_sgp" {
#   value = data.aws_secrutiy_groups.container_sgp.id
# }

data "aws_vpc" "vpc" {
    filter {
      name = "tag:Name"
      values = ["${var.service}*"]
  }
}

data "aws_iam_policy" "codedeploy_ecs_policy" {
    name = "AWSCodeDeployRoleForECS"
}

data "aws_iam_policy_document" "codedeploy_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["codedeploy.amazonaws.com"]
    }
  }
}