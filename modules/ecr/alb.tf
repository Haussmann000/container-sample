###################
## Blue デプロイ ##
###################

resource "aws_alb" "alb-internal" {
  name               = "${var.service}-alb-internal"
  internal           = true
  load_balancer_type = "application"
  security_groups = [
    "sg-02dc1df4c5cbc2cee"
  ]
  subnets = [
    "subnet-0a1ec3635d52e20fe",
    "subnet-0777dbf1cdf2fd528"
  ]
  tags  = {
      Name  = "${var.service}-alb-internal"
  }
}

resource "aws_alb_target_group" "tgp-internal-blue" {
    name               = "${var.service}-tgp-internal-blue"
    port = 80
    protocol = "HTTP"
    target_type = "ip"
    vpc_id = data.aws_vpc.vpc.id
    health_check {
      healthy_threshold = 3
      unhealthy_threshold = 2
      timeout = 5
      interval = 15
      matcher = "200"
    }
}
resource "aws_alb_target_group" "tgp-internal-green" {
    name               = "${var.service}-tgp-internal-green"
    port = 80
    protocol = "HTTP"
    target_type = "ip"
    vpc_id = data.aws_vpc.vpc.id
    health_check {
      path = "/healthcheck"
      healthy_threshold = 3
      unhealthy_threshold = 2
      timeout = 5
      interval = 15
      matcher = "200"
    }
}

resource "aws_alb_listener" "alb-listner-blue" {
  load_balancer_arn = aws_alb.alb-internal.arn
  port = "80"
  protocol = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_alb_target_group.tgp-internal-blue.arn
  }
}
resource "aws_alb_listener" "alb-listner-green" {
  load_balancer_arn = aws_alb.alb-internal.arn
  port = "10080"
  protocol = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_alb_target_group.tgp-internal-green.arn
  }
}


