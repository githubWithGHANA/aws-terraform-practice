resource "aws_vpc" "nit_vpc" {

  cidr_block           = "172.20.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(local.common_tags, {
    Name = "nit-dev-vpc"
  })
}

resource "aws_internet_gateway" "igw" {

  vpc_id = aws_vpc.nit_vpc.id

  tags = merge(local.common_tags, {
    Name = "nit-dev-igw"
  })
}

#subnet
data "aws_availability_zones" "azs" {}

resource "aws_subnet" "public_1" {

  vpc_id                  = aws_vpc.nit_vpc.id
  cidr_block              = "172.20.1.0/24"
  availability_zone       = data.aws_availability_zones.azs.names[0]
  map_public_ip_on_launch = true

  tags = merge(local.common_tags, {
    Name = "nit-dev-public-1"
  })
}

resource "aws_subnet" "public_2" {

  vpc_id                  = aws_vpc.nit_vpc.id
  cidr_block              = "172.20.2.0/24"
  availability_zone       = data.aws_availability_zones.azs.names[1]
  map_public_ip_on_launch = true

  tags = merge(local.common_tags, {
    Name = "nit-dev-public-2"
  })
}

resource "aws_subnet" "private_1" {

  vpc_id            = aws_vpc.nit_vpc.id
  cidr_block        = "172.20.10.0/24"
  availability_zone = data.aws_availability_zones.azs.names[0]

  tags = merge(local.common_tags, {
    Name = "nit-dev-private-1"
  })
}

resource "aws_subnet" "private_2" {

  vpc_id            = aws_vpc.nit_vpc.id
  cidr_block        = "172.20.11.0/24"
  availability_zone = data.aws_availability_zones.azs.names[1]

  tags = merge(local.common_tags, {
    Name = "nit-dev-private-2"
  })
}

#nat
resource "aws_eip" "nat_eip" {

  domain = "vpc"

  tags = merge(local.common_tags, {
    Name = "nit-dev-nat-eip"
  })
}

resource "aws_nat_gateway" "nat" {

  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_1.id

  tags = merge(local.common_tags, {
    Name = "nit-dev-nat-gw"
  })
}

#RouteTables
resource "aws_route_table" "public_rt" {

  vpc_id = aws_vpc.nit_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "nit-dev-public-rt"
  }
}

resource "aws_route_table_association" "public1" {

  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public2" {

  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table" "private_rt" {

  vpc_id = aws_vpc.nit_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "nit-dev-private-rt"
  }
}

resource "aws_route_table_association" "private1" {

  subnet_id      = aws_subnet.private_1.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private2" {

  subnet_id      = aws_subnet.private_2.id
  route_table_id = aws_route_table.private_rt.id
}