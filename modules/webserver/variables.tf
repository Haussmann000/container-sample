variable "key_name" {
    type = string
    default = "terraform-training"
}

variable "public_key_path" {
    type = string
    default = "/home/ec2-user/.ssh/authorized_keys"
}

variable "aws_profile" {
  type = string
}

variable "my_localhost" {
  type = list(string)
}

variable "my_name" {
  type = string
}

variable "region" {
 type = string
}