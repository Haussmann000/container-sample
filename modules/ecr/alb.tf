
#-----------------------------------------------------#
# AWS ALB                                             #
#-----------------------------------------------------#


#-- Green デプロイ --#
resource "aws_alb" "alb-internal-green" {
  name               = "${var.service}-alb-internal"
  internal           = true
  load_balancer_type = "application"
  security_groups = [
    "${aws_security_group.sbcntr_sgp_internal.id}"
  ]
  subnets = [
    "${aws_subnet.sbcntr_subnet_private_container_1a.id}",
    "${aws_subnet.sbcntr_subnet_private_container_1c.id}",
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
    vpc_id = aws_vpc.sbcntrVpc.id
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
    vpc_id = aws_vpc.sbcntrVpc.id
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
  load_balancer_arn = aws_alb.alb-internal-green.arn
  port = "80"
  protocol = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_alb_target_group.tgp-internal-blue.arn
  }
}
resource "aws_alb_listener" "alb-listner-green" {
  load_balancer_arn = aws_alb.alb-internal-green.arn
  port = "10080"
  protocol = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_alb_target_group.tgp-internal-green.arn
  }
}


