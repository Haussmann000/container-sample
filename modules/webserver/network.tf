
# ---------------------------------------------------------------------------
# VPC
# ---------------------------------------------------------------------------

resource "aws_vpc" "training" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "training-vpc-${var.my_name}"
  }
}

resource "aws_subnet" "public-1a" {
  vpc_id                  = aws_vpc.training.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "${var.region}a"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-1a-${var.my_name}"
  }
}


# ---------------------------------------------------------------------------
# SUBNET
# ---------------------------------------------------------------------------

resource "aws_subnet" "public-1c" {
  vpc_id                  = aws_vpc.training.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "${var.region}c"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-1c-${var.my_name}"
  }
}
resource "aws_subnet" "private-1a" {
  vpc_id                  = aws_vpc.training.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "${var.region}a"
  map_public_ip_on_launch = true

  tags = {
    Name = "private-1a-${var.my_name}"
  }
}

resource "aws_subnet" "private-1c" {
  vpc_id                  = aws_vpc.training.id
  cidr_block              = "10.0.4.0/24"
  availability_zone       = "${var.region}c"
  map_public_ip_on_launch = true

  tags = {
    Name = "private-1c-${var.my_name}"
  }
}


# ---------------------------------------------------------------------------
# IGW
# ---------------------------------------------------------------------------
resource "aws_internet_gateway" "training" {
  vpc_id = aws_vpc.training.id

  tags = {
    Name = "training-igw-${var.my_name}"
  }
}

# ---------------------------------------------------------------------------
# PUBLIC ROUTE TABLE
# ---------------------------------------------------------------------------

resource "aws_route_table" "training" {
  vpc_id = aws_vpc.training.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.training.id
  }

  tags = {
    Name = "training-rtb-${var.my_name}"
  }
}

resource "aws_route_table_association" "training" {
  subnet_id      = aws_subnet.private-1a.id
  route_table_id = aws_route_table.training.id
}
