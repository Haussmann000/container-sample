resource "aws_s3_bucket" "codebuild-test-987359833978" {
  bucket = "codebuild-test-987359833978"
}

resource "aws_s3_bucket_acl" "codebuild-test-987359833978" {
  bucket = aws_s3_bucket.codebuild-test-987359833978.id
  acl    = "private"
}