
# キーペア
resource "aws_key_pair" "terraform_key_pair" {
  key_name = var.key_name
  public_key = file("/files/ssh_devcontainer.pub")
}

# EC2インスタンス
resource "aws_instance" "terraform-server" {
  ami = data.aws_ami.amazon_linux.id
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.private-1a.id
  user_data     = file("${path.module}/files/user_data.sh")
  key_name      = aws_key_pair.terraform_key_pair.id
  iam_instance_profile = aws_iam_instance_profile.instance.name
  vpc_security_group_ids = [
    aws_security_group.web.id
  ]

  tags = {
    Name = "training-server-${var.my_name}"
  }
}

# EIP
resource "aws_eip" "training-eip" {
  instance = aws_instance.terraform-server.id
  vpc      = true
  depends_on = [
    aws_instance.terraform-server
  ]
  tags = {
    Name = "training-eip-${var.my_name}"
  }
}
