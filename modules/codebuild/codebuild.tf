resource "aws_codebuild_project" "codebuild-test_project" {
  name          = "test-project"
  description   = "test_codebuild_project"
  build_timeout = "5"
  service_role  = aws_iam_role.codebuild_test_role.arn

  artifacts {
    type = "S3"
    location = aws_s3_bucket.codebuild-test-987359833978.bucket
    packaging = "ZIP"
  }

  cache {
    type     = "S3"
    location = aws_s3_bucket.codebuild-test-987359833978.bucket
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:1.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "codebuild-test-log-group"
      stream_name = "codebuild-test-log-stream"
    }

    s3_logs {
      status   = "ENABLED"
      location = "${aws_s3_bucket.codebuild-test-987359833978.id}/build-log"
    }
  }

  source {
    type            = "CODECOMMIT"
    location        = data.aws_codecommit_repository.this.clone_url_http
  }

  tags = {
    Environment = "Test"
  }

}