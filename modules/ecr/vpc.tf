# S3 エンドポイント
resource "aws_vpc_endpoint" "s3" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${var.region}.s3"
  route_table_ids   = ["rtb-0b9c773cf9fcdb539"]
  vpc_endpoint_type = "Gateway"
  tags = {
    Name = "sbcntr-vpce-s3"
  }
}

# ECR APIエンドポイント
resource "aws_vpc_endpoint" "ECR_API" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${var.region}.ecr.api"
  subnet_ids = [
    "subnet-02a0da22c79ed2a04",
    "subnet-078240470b8c32946"
  ]
  security_group_ids = [
    "sg-07775d53187955374"
  ]
  vpc_endpoint_type = "Interface"
  private_dns_enabled = true
  tags = {
    Name  = "sbcntr-vpce-ecr-api"
  }
}

# ECR DKRエンドポイント
resource "aws_vpc_endpoint" "ECR_DKR" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${var.region}.ecr.dkr"
  subnet_ids = [
    "subnet-02a0da22c79ed2a04",
    "subnet-078240470b8c32946"
  ]
  security_group_ids = [
    "sg-07775d53187955374"
  ]
  vpc_endpoint_type = "Interface"
  private_dns_enabled = true
  tags = {
    Name  = "sbcntr-vpce-ecr-dkr"
  }
}

##########################################
## Fargate Cloudwatch logsエンドポイント##
##########################################
resource "aws_vpc_endpoint" "Fargate_CWlogs" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${var.region}.logs"
  subnet_ids = [
    "subnet-02a0da22c79ed2a04",
    "subnet-078240470b8c32946"
  ]
  security_group_ids = [
    "sg-07775d53187955374"
  ]
  vpc_endpoint_type = "Interface"
  private_dns_enabled = true
  tags = {
    Name  = "sbcntr-vpce-logs"
  }
}
