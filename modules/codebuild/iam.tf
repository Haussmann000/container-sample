resource "aws_iam_role" "codebuild_test_role" {
  name = "codebuild_test_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
  managed_policy_arns = [
      data.aws_iam_policy.codedeploy_full_policy.arn,
      data.aws_iam_policy.cloudwatchlogs_full_policy.arn,
      # https://teratail.com/questions/363058
      data.aws_iam_policy.codecommit_power_policy.arn
    ]
}