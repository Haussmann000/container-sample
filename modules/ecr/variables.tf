# variable "vpc_id" {
#   default = "vpc-045a3ec5123b5aef1"
# }

variable "region" {
 type = string
}

variable "service" {
  type = string
}

variable "aws_profile" {
  type = string
}

variable "my_ips" {
  type = list(string)
  default = [ "0.0.0.0/0" ]
}
