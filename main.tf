data "aws_region" "current" {

}
resource "aws_vpc" "vpc" {

  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    "Name" = "${var.name_prefix}-vpc"
  }

}

resource "aws_default_security_group" "vpc-default-sg" {

  vpc_id = aws_vpc.vpc.id
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}


resource "aws_default_route_table" "default-rt" {

  default_route_table_id = aws_vpc.vpc.default_route_table_id

}

resource "aws_internet_gateway" "igw" {

  vpc_id = aws_vpc.vpc.id

}


resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_subnet" "public-subnet" {
  for_each                = var.public_subnets
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = each.value
  availability_zone       = format("%s%s", data.aws_region.current.name, each.key)
  map_public_ip_on_launch = "true"
  tags = merge({
    "Name" = format("%s-public-%s", var.name_prefix, each.key)
  }, var.extra_public_subnet_tags)
}
resource "aws_route_table_association" "public-rba" {
  for_each = var.public_subnets

  subnet_id      = aws_subnet.public-subnet[each.key].id
  route_table_id = aws_route_table.public-rt.id
}
resource "aws_eip" "nateip" {
  for_each = toset(var.natgateway)
  vpc      = true
  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_nat_gateway" "natgw" {
  for_each      = toset(var.natgateway)
  allocation_id = aws_eip.nateip[each.key].id
  subnet_id     = aws_subnet.public-subnet[each.key].id
  depends_on    = [aws_internet_gateway.igw]
}

resource "aws_subnet" "private-subnet" {
  for_each                = var.private_subnets
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = each.value
  availability_zone       = format("%s%s", data.aws_region.current.name, each.key)
  map_public_ip_on_launch = "false"
  tags = merge({
    "Name" = format("%s-private-%s", var.name_prefix, each.key)
  }, var.extra_private_subnet_tags)
}

resource "aws_route_table" "private-rt" {
  for_each = var.private_subnets
  vpc_id   = aws_vpc.vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = contains(var.natgateway, each.key) ? aws_nat_gateway.natgw[each.key].id : aws_nat_gateway.natgw[var.natgateway[0]].id
  }

}
resource "aws_route_table_association" "private-rba" {
  for_each = var.private_subnets

  subnet_id      = aws_subnet.private-subnet[each.key].id
  route_table_id = aws_route_table.private-rt[each.key].id
}
