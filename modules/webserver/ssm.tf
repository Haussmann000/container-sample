# エンドポイント用のセキュリティグループ
resource "aws_security_group" "endpoint" {
  name   = "endpoint"
  vpc_id = aws_vpc.training.id
}

# エンドポイントに対する HTTPS 通信を許可
resource "aws_security_group_rule" "endpoint_ingress_https" {
  security_group_id = aws_security_group.endpoint.id
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 0
  to_port           = 443
  protocol          = "tcp"
}

# ssm エンドポイント
resource "aws_vpc_endpoint" "ssm" {
  vpc_id            = aws_vpc.training.id
  service_name      = "com.amazonaws.${var.region}.ssm"
  vpc_endpoint_type = "Interface"

  security_group_ids  = [aws_security_group.endpoint.id]
  subnet_ids          = [aws_subnet.private-1a.id]
  private_dns_enabled = true
}

# ssmmessages エンドポイント
resource "aws_vpc_endpoint" "ssmmessages" {
  vpc_id            = aws_vpc.training.id
  service_name      = "com.amazonaws.${var.region}.ssmmessages"
  vpc_endpoint_type = "Interface"

  security_group_ids  = [aws_security_group.endpoint.id]
  subnet_ids          = [aws_subnet.private-1a.id]
  private_dns_enabled = true
}

# ec2messages エンドポイント
resource "aws_vpc_endpoint" "ec2messages" {
  vpc_id            = aws_vpc.training.id
  service_name      = "com.amazonaws.${var.region}.ec2messages"
  vpc_endpoint_type = "Interface"

  security_group_ids  = [aws_security_group.endpoint.id]
  subnet_ids          = [aws_subnet.private-1a.id]
  private_dns_enabled = true
}

# S3 エンドポイント
resource "aws_vpc_endpoint" "s3" {
  vpc_id            = aws_vpc.training.id
  service_name = "com.amazonaws.${var.region}.s3"
  route_table_ids = ["${aws_route_table.training.id}"]
}


# AmazonSSMManagedInstanceCore の情報を取得
data "aws_iam_policy" "ssm_core" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# IAM ロール
resource "aws_iam_role" "instance" {
  name               = "instance"
  assume_role_policy = file("${path.module}/files/policy.json")
}

# IAM ロールにポリシーを付与
resource "aws_iam_role_policy" "instance_ssm" {
  name   = "instance_ssm"
  role   = aws_iam_role.instance.id
  policy = data.aws_iam_policy.ssm_core.policy
}

# 作成した IAM ロールを割り当てた IAM インスタンスプロファイル
resource "aws_iam_instance_profile" "instance" {
  name = "instance"
  role = aws_iam_role.instance.name
}
