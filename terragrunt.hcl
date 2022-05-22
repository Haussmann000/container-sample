# --------------------------------------------------------------------------------
# ローカル属性定義
# --------------------------------------------------------------------------------

locals {
  aws_account_id = "987359833978"
  aws_region_id  = "ap-northeast-1"
  env            = "dev"
  service        = "container-sample"
}

# --------------------------------------------------------------------------------
# provider.tf テンプレート
# --------------------------------------------------------------------------------

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  allowed_account_ids = ["${local.aws_account_id}"]
  profile             = "default" 
  region              = "${local.aws_region_id}"
}
provider "aws" {
  allowed_account_ids = ["${local.aws_account_id}"]
  profile             = "default"
  region              = "us-east-1"
  alias               = "us-east-1"
}
EOF
}

# --------------------------------------------------------------------------------
# backend.tf テンプレート
# --------------------------------------------------------------------------------

remote_state {
  backend = "s3"
  config = {
    bucket  = "${local.service}-${local.env}-tfstate-${local.aws_account_id}-1"
    encrypt = true
    key     = "tfstate/${local.service}/${local.env}/${path_relative_to_include()}/terraform.tfstate"
    region  = local.aws_region_id
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}

# --------------------------------------------------------------------------------
# グローバル属性定義
# --------------------------------------------------------------------------------

inputs = {
  account = {
    id = local.aws_account_id
  },
  region = {
    id = local.aws_region_id
  },
  tags = {
    env     = local.env
    service = local.service
  }
}
