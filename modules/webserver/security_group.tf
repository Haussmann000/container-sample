resource "aws_security_group" "web" {
  name   = "web"
  vpc_id = aws_vpc.training.id

  ingress {
    description = "allow http"
    from_port   = "80"
    to_port     = "80"
    protocol    = "tcp"
    cidr_blocks = var.my_localhost
  }
  ingress {
    description = "allow ssh"
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = var.my_localhost
  }
  egress {
    description = "allow https"
    from_port   = "443"
    to_port     = "443"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description = "allow http"
    from_port   = "80"
    to_port     = "80"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "training-sgp-${var.my_name}"
  }
}