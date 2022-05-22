terraform {
  backend "s3" {
    bucket  = "aws-training-tfstate-84"
    key     = "takaba/terraform.tfstate"
    profile = "devops_stg"
    region  = "ap-northeast-1"
  }
}