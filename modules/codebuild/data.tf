data "aws_iam_policy" "codedeploy_full_policy" {
    name = "AWSCodeDeployFullAccess"
}

data "aws_iam_policy" "cloudwatchlogs_full_policy" {
    name = "CloudWatchLogsFullAccess"
}
data "aws_iam_policy" "codecommit_power_policy" {
    name = "AWSCodeCommitPowerUser"
}

data "aws_codecommit_repository" "this" {
  repository_name = "jolt"
}