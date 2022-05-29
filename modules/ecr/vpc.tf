#-----------------------------------------------------#
# AWS VPC                                             #
#-----------------------------------------------------#

resource "aws_vpc" "sbcntrVpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true
}


#-----------------------------------------------------#
# AWS Subnets                                         #
#-----------------------------------------------------#

resource "aws_subnet" "sbcntr_subnet_public_ingress_1a" {
  vpc_id = aws_vpc.sbcntrVpc.id
  cidr_block = "10.0.0.0/24"
}
resource "aws_subnet" "sbcntr_subnet_public_ingress_1c" {
  vpc_id = aws_vpc.sbcntrVpc.id
  cidr_block = "10.0.1.0/24"
}
resource "aws_subnet" "sbcntr_subnet_private_container_1a" {
  vpc_id = aws_vpc.sbcntrVpc.id
  cidr_block = "10.0.8.0/24"
  availability_zone = "ap-northeast-1a"
}
resource "aws_subnet" "sbcntr_subnet_private_container_1c" {
  vpc_id = aws_vpc.sbcntrVpc.id
  cidr_block = "10.0.9.0/24"
  availability_zone = "ap-northeast-1c"
}
resource "aws_subnet" "sbcntr_subnet_private_db_1a" {
  vpc_id = aws_vpc.sbcntrVpc.id
  cidr_block = "10.0.16.0/24"
}
resource "aws_subnet" "sbcntr_subnet_private_db_1c" {
  vpc_id = aws_vpc.sbcntrVpc.id
  cidr_block = "10.0.17.0/24"
}
resource "aws_subnet" "sbcntr_subnet_public_management_1a" {
  vpc_id = aws_vpc.sbcntrVpc.id
  cidr_block = "10.0.240.0/24"
}
resource "aws_subnet" "sbcntr_subnet_public_management_1c" {
  vpc_id = aws_vpc.sbcntrVpc.id
  cidr_block = "10.0.241.0/24"
}
resource "aws_subnet" "sbcntr_subnet_private_egress_1a" {
  vpc_id = aws_vpc.sbcntrVpc.id
  cidr_block = "10.0.247.0/24"
}
resource "aws_subnet" "sbcntr_subnet_private_egress_1c" {
  vpc_id = aws_vpc.sbcntrVpc.id
  cidr_block = "10.0.248.0/24"
}



#-----------------------------------------------------#
# AWS Internet Gateway                                #
#-----------------------------------------------------#

resource "aws_internet_gateway" "sbcntr_igw" {
  vpc_id = aws_vpc.sbcntrVpc.id
}


#-----------------------------------------------------#
# AWS Route Table for Ingress                         #
#-----------------------------------------------------#

resource "aws_route_table" "sbcntr_route_ingress" {
  vpc_id = aws_vpc.sbcntrVpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.sbcntr_igw.id
  }
}

#-----------------------------------------------------#
# AWS Route Table Association for Ingress             #
#-----------------------------------------------------#

resource "aws_route_table_association" "sbcntr_rtb_association_management_a" {
  route_table_id = aws_route_table.sbcntr_route_ingress.id
  subnet_id = aws_subnet.sbcntr_subnet_public_management_1a.id
}
resource "aws_route_table_association" "sbcntr_rtb_association_management_c" {
  route_table_id = aws_route_table.sbcntr_route_ingress.id
  subnet_id = aws_subnet.sbcntr_subnet_public_management_1c.id
}
resource "aws_route_table_association" "sbcntr_rtb_association_ingress_a" {
  route_table_id = aws_route_table.sbcntr_route_ingress.id
  subnet_id = aws_subnet.sbcntr_subnet_public_ingress_1a.id
}
resource "aws_route_table_association" "sbcntr_rtb_association_ingress_c" {
  route_table_id = aws_route_table.sbcntr_route_ingress.id
  subnet_id = aws_subnet.sbcntr_subnet_public_ingress_1c.id
}


#-----------------------------------------------------#
# AWS Route Table for App                             #
#-----------------------------------------------------#

resource "aws_route_table" "sbcntr_route_app" {
  vpc_id = aws_vpc.sbcntrVpc.id
}

#-----------------------------------------------------#
# AWS Route Table Association for App                 #
#-----------------------------------------------------#

resource "aws_route_table_association" "sbcntr_rtb_association_app_a" {
  route_table_id = aws_route_table.sbcntr_route_app.id
  subnet_id = aws_subnet.sbcntr_subnet_private_container_1a.id
}
resource "aws_route_table_association" "sbcntr_rtb_association_app_c" {
  route_table_id = aws_route_table.sbcntr_route_app.id
  subnet_id = aws_subnet.sbcntr_subnet_private_container_1c.id
}

#-----------------------------------------------------#
# AWS Route Table for DB                              #
#-----------------------------------------------------#

resource "aws_route_table" "sbcntr_route_db" {
  vpc_id = aws_vpc.sbcntrVpc.id
}

#-----------------------------------------------------#
# AWS Route Table Association for DB                  #
#-----------------------------------------------------#

resource "aws_route_table_association" "sbcntr_rtb_association_db_a" {
  route_table_id = aws_route_table.sbcntr_route_db.id
  subnet_id = aws_subnet.sbcntr_subnet_private_db_1a.id
}
resource "aws_route_table_association" "sbcntr_rtb_association_db_c" {
  route_table_id = aws_route_table.sbcntr_route_db.id
  subnet_id = aws_subnet.sbcntr_subnet_private_db_1c.id
}

#-----------------------------------------------------#
# AWS Security Group for Ingress                      #
#-----------------------------------------------------#
resource "aws_security_group" "sbcntr_sgp_ingress" {
  name = "ingress"
  vpc_id = aws_vpc.sbcntrVpc.id
}

#-----------------------------------------------------#
# AWS Security Group Rules for Ingress                 #
#-----------------------------------------------------#
resource "aws_security_group_rule" "sbcntr_sgp_ingress" {
  type = "ingress"
  security_group_id = aws_security_group.sbcntr_sgp_ingress.id
  from_port = 80
  to_port = 80
  protocol = "tcp"
  cidr_blocks = var.my_ips
}


#-----------------------------------------------------#
# AWS Security Group for Container                   #
#-----------------------------------------------------#

resource "aws_security_group" "sbcntr_sgp_container" {
  name = "container"
  description = "Security Group of backend app"
  vpc_id = aws_vpc.sbcntrVpc.id
}

#-----------------------------------------------------#
# AWS Security Group Rules for Container               #
#-----------------------------------------------------#

resource "aws_security_group_rule" "sbcntr_sgp_container_rule" {
  type = "ingress"
  description = "HTTP for internal lb"
  security_group_id = aws_security_group.sbcntr_sgp_container.id
  from_port = 80
  to_port = 80
  protocol = "tcp"
  source_security_group_id = aws_security_group.sbcntr_sgp_internal.id
}


#-----------------------------------------------------#
# AWS Security Group for DB                           #
#-----------------------------------------------------#

resource "aws_security_group" "sbcntr_sgp_db" {
  name = "db"
  description = "Security Group of database"
  vpc_id = aws_vpc.sbcntrVpc.id
}

#-----------------------------------------------------#
# AWS Security Group Rules for DB                      #
#-----------------------------------------------------#

resource "aws_security_group_rule" "sbcntr_sgp_db_management" {
  type = "ingress"
  description = "MySQL protocol from management server"
  security_group_id = aws_security_group.sbcntr_sgp_db.id
  from_port = 3306
  to_port = 3306
  protocol = "tcp"
  source_security_group_id = aws_security_group.sbcntr_sgp_management.id
}

#-----------------------------------------------------#
# AWS Security Group Rules for DB                      #
#-----------------------------------------------------#
resource "aws_security_group_rule" "sbcntr_sgp_db_container" {
  type = "ingress"
  description = "MySQL protocol from backend App"
  security_group_id = aws_security_group.sbcntr_sgp_db.id
  from_port = 3306
  to_port = 3306
  protocol = "tcp"
  source_security_group_id = aws_security_group.sbcntr_sgp_container.id
}

resource "aws_security_group_rule" "sbcntr_sgp_db_front" {
  type = "ingress"
  description = "MySQL protocol from frontend App"
  security_group_id = aws_security_group.sbcntr_sgp_db.id
  from_port = 3306
  to_port = 3306
  protocol = "tcp"
  source_security_group_id = aws_security_group.sbcntr_sgp_front_container.id
}


#-----------------------------------------------------#
# AWS Security Group for Front Container              #
#-----------------------------------------------------#
resource "aws_security_group" "sbcntr_sgp_front_container" {
  name = "front-container"
  description = "Security Group of front container app"
  vpc_id = aws_vpc.sbcntrVpc.id
}

#-----------------------------------------------------#
# AWS Security Group Rules for Container               #
#-----------------------------------------------------#

resource "aws_security_group_rule" "sbcntr_sgp_front_container" {
  type = "ingress"
  description = "HTTP for Ingress"
  security_group_id = aws_security_group.sbcntr_sgp_front_container.id
  from_port = 80
  to_port = 80
  protocol = "tcp"
  source_security_group_id = aws_security_group.sbcntr_sgp_ingress.id
}

#-----------------------------------------------------#
# AWS Security Group Rules for Load Balancer           #
#-----------------------------------------------------#

resource "aws_security_group" "sbcntr_sgp_internal" {
  name = "internal"
  description = "Security group for internal load balancer"
  vpc_id = aws_vpc.sbcntrVpc.id
}
#-----------------------------------------------------#
# AWS Security Group Rules for Load Balancer          #
#-----------------------------------------------------#
resource "aws_security_group_rule" "sbcntr_sgp_internal_management" {
  type = "ingress"
  description = "HTTP for management server"
  security_group_id = aws_security_group.sbcntr_sgp_internal.id
  from_port = 80
  to_port = 80
  protocol = "tcp"
  source_security_group_id = aws_security_group.sbcntr_sgp_management.id
}
resource "aws_security_group_rule" "sbcntr_sgp_internal_container" {
  type = "ingress"
  description = "HTTP for front container"
  security_group_id = aws_security_group.sbcntr_sgp_internal.id
  from_port = 80
  to_port = 80
  protocol = "tcp"
  source_security_group_id = aws_security_group.sbcntr_sgp_container.id
}


#-----------------------------------------------------#
# AWS Security Group for VPC Endpoints                #
#-----------------------------------------------------#
resource "aws_security_group" "sbcntr_sgp_vpce" {
  name = "vpce"
  description = "Security Group of VPC Endpoint"
  vpc_id = aws_vpc.sbcntrVpc.id
}
#-----------------------------------------------------#
# AWS Security Group Rules for VPC Endpoints           #
#-----------------------------------------------------#
resource "aws_security_group_rule" "sbcntr_sgp_vpce_front" {
  type = "ingress"
  description = "HTTPS for Front Container App"
  security_group_id = aws_security_group.sbcntr_sgp_vpce.id
  from_port = 443
  to_port = 443
  protocol = "tcp"
  source_security_group_id = aws_security_group.sbcntr_sgp_front_container.id
}
resource "aws_security_group_rule" "sbcntr_sgp_vpce_container" {
  type = "ingress"
  description = "HTTPS for Container App"
  security_group_id = aws_security_group.sbcntr_sgp_vpce.id
  from_port = 443
  to_port = 443
  protocol = "tcp"
  source_security_group_id = aws_security_group.sbcntr_sgp_container.id
}
resource "aws_security_group_rule" "sbcntr_sgp_vpce_management" {
  type = "ingress"
  description = "HTTPS for management server"
  security_group_id = aws_security_group.sbcntr_sgp_vpce.id
  from_port = 443
  to_port = 443
  protocol = "tcp"
  source_security_group_id = aws_security_group.sbcntr_sgp_management.id
}

#-----------------------------------------------------#
# AWS Security Group for Management                   #
#-----------------------------------------------------#

resource "aws_security_group" "sbcntr_sgp_management" {
  name = "management"
  description = "Security Group of management server"
  vpc_id = aws_vpc.sbcntrVpc.id
}

#-----------------------------------------------------#
# AWS Security Group for egress                       #
#-----------------------------------------------------#

resource "aws_security_group" "sbcntr_sgp_egress" {
  name = "egress"
  description = "Security Group of egress"
  vpc_id = aws_vpc.sbcntrVpc.id
}



#-----------------------------------------------------#
# AWS S3 Endpoint                                     #
#-----------------------------------------------------#
resource "aws_vpc_endpoint" "s3" {
  vpc_id            = aws_vpc.sbcntrVpc.id
  service_name      = "com.amazonaws.${var.region}.s3"
  route_table_ids   = ["${aws_route_table.sbcntr_route_ingress.id}"]
  vpc_endpoint_type = "Gateway"
  tags = {
    Name = "sbcntr-vpce-s3"
  }
}

#-----------------------------------------------------#
# AWS ECR Endpoint                                    #
#-----------------------------------------------------#
resource "aws_vpc_endpoint" "ECR_API" {
  vpc_id            = aws_vpc.sbcntrVpc.id
  service_name      = "com.amazonaws.${var.region}.ecr.api"
  subnet_ids = [
    "${aws_subnet.sbcntr_subnet_private_egress_1a.id}",
    "${aws_subnet.sbcntr_subnet_private_egress_1c.id}"
  ]
  security_group_ids = [
    "${aws_security_group.sbcntr_sgp_vpce.id}"
  ]
  vpc_endpoint_type = "Interface"
  private_dns_enabled = true
  tags = {
    Name  = "sbcntr-vpce-ecr-api"
  }
}

#-----------------------------------------------------#
# AWS DKR Endpoint                                    #
#-----------------------------------------------------#
resource "aws_vpc_endpoint" "ECR_DKR" {
  vpc_id            = aws_vpc.sbcntrVpc.id
  service_name      = "com.amazonaws.${var.region}.ecr.dkr"
  subnet_ids = [
    "${aws_subnet.sbcntr_subnet_private_egress_1a.id}",
    "${aws_subnet.sbcntr_subnet_private_egress_1c.id}"
  ]
  security_group_ids = [
    "${aws_security_group.sbcntr_sgp_vpce.id}"
  ]
  vpc_endpoint_type = "Interface"
  private_dns_enabled = true
  tags = {
    Name  = "sbcntr-vpce-ecr-dkr"
  }
}

#-----------------------------------------------------#
# Fargate Cloudwatch logsエンドポイント                #
#-----------------------------------------------------#
resource "aws_vpc_endpoint" "Fargate_CWlogs" {
  vpc_id            = aws_vpc.sbcntrVpc.id
  service_name      = "com.amazonaws.${var.region}.logs"
  subnet_ids = [
    "${aws_subnet.sbcntr_subnet_private_egress_1a.id}",
    "${aws_subnet.sbcntr_subnet_private_egress_1c.id}"
  ]
  security_group_ids = [
    "${aws_security_group.sbcntr_sgp_vpce.id}"
  ]
  vpc_endpoint_type = "Interface"
  private_dns_enabled = true
  tags = {
    Name  = "sbcntr-vpce-logs"
  }
}
