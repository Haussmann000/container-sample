
#######################
# 現在のregionを取得
#######################
# data "aws_region" "current" {
#   current = true
# }


#######################
# 最新のAMIを取得
#######################
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

