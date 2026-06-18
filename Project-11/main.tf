# Create VPC
resource "aws_vpc" "prod_vpc" {
  cidr_block = "10.0.0.0/16"
    enable_dns_hostnames = true
    enable_dns_support   = true

 tags = {
    Name = "prod-vpc"
    Environment = "prod"
    Project = "VPC-Project"
    Owner = "Rohit"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.prod_vpc.id

  tags = {
    Name = "prod-igw"
  }
}
    
# Elastic IPs for NAT Gateways

resource "aws_eip" "nat_A" {
  domain = "vpc"

  tags = {
    Name = "nat-eip-A"
  }
}

resource "aws_eip" "nat_B" {
  domain = "vpc"

  tags = {
    Name = "nat-eip-B"
  }
}

# NAT Gateways

resource "aws_nat_gateway" "nat_A" {
  allocation_id = aws_eip.nat_A.id
  subnet_id     = aws_subnet.public_A.id

  tags = {
    Name = "nat-A"
  }

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_nat_gateway" "nat_B" {
  allocation_id = aws_eip.nat_B.id
  subnet_id     = aws_subnet.public_B.id

  tags = {
    Name = "nat-B"
  }

  depends_on = [aws_internet_gateway.igw]
}


# Public Route Table

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.prod_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-rt"
  }
}

resource "aws_route_table_association" "public_A" {
  subnet_id      = aws_subnet.public_A.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_B" {
  subnet_id      = aws_subnet.public_B.id
  route_table_id = aws_route_table.public_rt.id
}

# Private Route Table A

resource "aws_route_table" "private_rt_a" {
  vpc_id = aws_vpc.prod_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_A.id
  }

  tags = {
    Name = "private-rt-a"
  }
}

resource "aws_route_table_association" "private_app_a" {
  subnet_id      = aws_subnet.private_app_A.id
  route_table_id = aws_route_table.private_rt_a.id
}

resource "aws_route_table_association" "private_db_a" {
  subnet_id      = aws_subnet.private_db_A.id
  route_table_id = aws_route_table.private_rt_a.id
}

# Private Route Table B

resource "aws_route_table" "private_rt_b" {
  vpc_id = aws_vpc.prod_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_B.id
  }

  tags = {
    Name = "private-rt-b"
  }
}

resource "aws_route_table_association" "private_app_b" {
  subnet_id      = aws_subnet.private_app_B.id
  route_table_id = aws_route_table.private_rt_b.id
}

resource "aws_route_table_association" "private_db_b" {
  subnet_id      = aws_subnet.private_db_B.id
  route_table_id = aws_route_table.private_rt_b.id
}