# Generated by Terragrunt. Sig: nIlQXj57tbuaRZEa
provider "aws" {
  allowed_account_ids = ["987359833978"]
  profile             = "default" 
  region              = "ap-northeast-1"
}
provider "aws" {
  allowed_account_ids = ["987359833978"]
  profile             = "default"
  region              = "us-east-1"
  alias               = "us-east-1"
}