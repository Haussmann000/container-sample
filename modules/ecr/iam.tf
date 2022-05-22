resource "aws_iam_role" "codedeploy_ecs_role" {
  name = "codedeploy_ecs_role"
  managed_policy_arns = [data.aws_iam_policy.codedeploy_ecs_policy.arn]
  assume_role_policy = data.aws_iam_policy_document.codedeploy_assume_role_policy.json
}