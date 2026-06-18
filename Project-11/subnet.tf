# Public Subnets

# Subnet A
resource "aws_subnet" "public_A" {
  vpc_id                  = aws_vpc.prod_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-A"
  }
}

# Subnet B
resource "aws_subnet" "public_B" {
  vpc_id                  = aws_vpc.prod_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "ap-south-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-B"
  }
}

# Private App Subnets
# Private Subnet A
resource "aws_subnet" "private_app_A" {
  vpc_id            = aws_vpc.prod_vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "ap-south-1a"

  tags = {
    Name = "private-app-A"
  }
}

resource "aws_subnet" "private_app_B" {
  vpc_id            = aws_vpc.prod_vpc.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "ap-south-1b"

  tags = {
    Name = "private-app-B"
  }
}

# Private DB Subnets
# Private Subnet A
resource "aws_subnet" "private_db_A" {
  vpc_id            = aws_vpc.prod_vpc.id
  cidr_block        = "10.0.5.0/24"
  availability_zone = "ap-south-1a"

  tags = {
    Name = "private-db-A"
  }
}

resource "aws_subnet" "private_db_B" {
  vpc_id            = aws_vpc.prod_vpc.id
  cidr_block        = "10.0.6.0/24"
  availability_zone = "ap-south-1b"

  tags = {
    Name = "private-db-B"
  }
}