#######################################################
# AWS VPC                                             #
#######################################################

resource "aws_vpc" "sbcntrVpc" {
  cidr_block = "10.0.0.0/16"
}


#######################################################
# AWS Subnets                                         #
#######################################################

resource "aws_subnet" "sbcntr_subnet-public-ingress-1a" {
  vpc_id = aws_vpc.sbcntrVpc.id
  cidr_block = "10.0.0.0/24"
}
resource "aws_subnet" "sbcntr_subnet-public-ingress-1c" {
  vpc_id = aws_vpc.sbcntrVpc.id
  cidr_block = "10.0.1.0/24"
}
resource "aws_subnet" "sbcntr_subnet-private-container-1a" {
  vpc_id = aws_vpc.sbcntrVpc.id
  cidr_block = "10.0.8.0/24"
}
resource "aws_subnet" "sbcntr_subnet-private-container-1c" {
  vpc_id = aws_vpc.sbcntrVpc.id
  cidr_block = "10.0.8.0/24"
}
resource "aws_subnet" "sbcntr_subnet-private-db-1a" {
  vpc_id = aws_vpc.sbcntrVpc.id
  cidr_block = "10.0.16.0/24"
}
resource "aws_subnet" "sbcntr_subnet-private-db-1c" {
  vpc_id = aws_vpc.sbcntrVpc.id
  cidr_block = "10.0.17.0/24"
}
resource "aws_subnet" "sbcntr_subnet-public-management-1a" {
  vpc_id = aws_vpc.sbcntrVpc.id
  cidr_block = "10.0.240.0/24"
}
resource "aws_subnet" "sbcntr_subnet-public-management-1c" {
  vpc_id = aws_vpc.sbcntrVpc.id
  cidr_block = "10.0.241.0/24"
}


resource "aws_internet_gateway" "sbcntr_igw" {
  vpc_id = aws_vpc.sbcntrVpc.id
}

resource "aws_route_table" "sbcntr_rtb" {
  vpc_id = aws_vpc.sbcntrVpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.sbcntr_igw.id
  }
}

resource "aws_security_group" "sbcntr_sgp_ingress" {
  name = "ingress"
  vpc_id = aws_vpc.sbcntrVpc.id

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = var.my_ips
  }
}

#######################################################
# AWS S3 Endpoint                                     #
#######################################################
resource "aws_vpc_endpoint" "s3" {
  vpc_id            = aws_vpc.sbcntrVpc.id
  service_name      = "com.amazonaws.${var.region}.s3"
  route_table_ids   = ["${aws_route_table.sbcntr_rtb.id}"]
  vpc_endpoint_type = "Gateway"
  tags = {
    Name = "sbcntr-vpce-s3"
  }
}

# #######################################################
# # AWS ECR Endpoint                                    #
# #######################################################
# resource "aws_vpc_endpoint" "ECR_API" {
#   vpc_id            = aws_vpc.sbcntrVpc.id
#   service_name      = "com.amazonaws.${var.region}.ecr.api"
#   subnet_ids = [
#     "subnet-02a0da22c79ed2a04",
#     "subnet-078240470b8c32946"
#   ]
#   security_group_ids = [
#     "sg-07775d53187955374"
#   ]
#   vpc_endpoint_type = "Interface"
#   private_dns_enabled = true
#   tags = {
#     Name  = "sbcntr-vpce-ecr-api"
#   }
# }

# #######################################################
# # AWS DKR Endpoint                                    #
# #######################################################
# resource "aws_vpc_endpoint" "ECR_DKR" {
#   vpc_id            = aws_vpc.sbcntrVpc.id
#   service_name      = "com.amazonaws.${var.region}.ecr.dkr"
#   subnet_ids = [
#     "subnet-02a0da22c79ed2a04",
#     "subnet-078240470b8c32946"
#   ]
#   security_group_ids = [
#     "sg-07775d53187955374"
#   ]
#   vpc_endpoint_type = "Interface"
#   private_dns_enabled = true
#   tags = {
#     Name  = "sbcntr-vpce-ecr-dkr"
#   }
# }

# ##########################################
# ## Fargate Cloudwatch logsエンドポイント##
# ##########################################
# resource "aws_vpc_endpoint" "Fargate_CWlogs" {
#   vpc_id            = aws_vpc.sbcntrVpc.id
#   service_name      = "com.amazonaws.${var.region}.logs"
#   subnet_ids = [
#     "subnet-02a0da22c79ed2a04",
#     "subnet-078240470b8c32946"
#   ]
#   security_group_ids = [
#     "sg-07775d53187955374"
#   ]
#   vpc_endpoint_type = "Interface"
#   private_dns_enabled = true
#   tags = {
#     Name  = "sbcntr-vpce-logs"
#   }
# }
