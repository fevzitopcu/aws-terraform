locals {
  public_subnets = {
    "${var.region}a" = "10.0.10.0/24"
    "${var.region}b" = "10.0.20.0/24"
    "${var.region}c" = "10.0.30.0/24"

  }
  private_subnets = {
    "${var.region}a" = "10.0.11.0/24"
    "${var.region}b" = "10.0.21.0/24"
    "${var.region}c" = "10.0.31.0/24"

  }
}
# Create VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  enable_dns_support   = true
  enable_dns_hostnames = true


  tags = {
    Name = "${var.service_name}-vpc"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.service_name}-internet-gateway"
  }
}

resource "aws_subnet" "public" {
  count      = length(local.public_subnets)
  cidr_block = element(values(local.public_subnets), count.index)
  vpc_id     = aws_vpc.main.id

  map_public_ip_on_launch = true
  availability_zone       = element(keys(local.public_subnets), count.index)

  tags = {
    Name = "${var.service_name}-service-public"
  }
}

resource "aws_subnet" "private" {
  count      = length(local.private_subnets)
  cidr_block = element(values(local.private_subnets), count.index)
  vpc_id     = aws_vpc.main.id

  map_public_ip_on_launch = false
  availability_zone       = element(keys(local.private_subnets), count.index)

  tags = {
    Name = "${var.service_name}-service-private"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.service_name}-public-RT"
  }
}

resource "aws_route" "public_internet_gateway" {
  count                  = length(local.public_subnets)
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id

  timeouts {
    create = "5m"
  }
}

resource "aws_route_table_association" "public" {
  count          = length(local.public_subnets)
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.service_name}-private-RT"
  }
}

resource "aws_route" "private_NAT_GW_route" {

  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_nat_gateway.NAT-Gateway.id

  timeouts {
    create = "5m"
  }
}
resource "aws_route_table_association" "private" {
  count          = length(local.private_subnets)
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = aws_route_table.private.id
}

data "aws_eip" "NAT-Gateway-EIP" {
  allocation_id = " "
}

resource "aws_nat_gateway" "NAT-Gateway" {

  allocation_id = data.aws_eip.NAT-Gateway-EIP.id
  subnet_id     = aws_subnet.public[0].id

  tags = {
    Name = "${var.service_name}-NAT-Gateway"
  }
}

resource "aws_network_acl" "NACL-public-subnet" {
  vpc_id = aws_vpc.main.id
  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }


  tags = {
    Name = "${var.service_name}-NACL-public"
  }
}
resource "aws_network_acl_association" "NACL-public-association" {
  network_acl_id = aws_network_acl.NACL-public-subnet.id
  count          = length(local.public_subnets)
  subnet_id      = element(aws_subnet.public.*.id, count.index)

}

resource "aws_network_acl" "NACL-private-subnet" {
  vpc_id = aws_vpc.main.id
  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = aws_vpc.main.cidr_block
    from_port  = 80
    to_port    = 80
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = aws_vpc.main.cidr_block
    from_port  = 80
    to_port    = 80
  }

  tags = {
    Name = "${var.service_name}-NACL-private"
  }
}

resource "aws_network_acl_association" "NACL-private-association" {
  network_acl_id = aws_network_acl.NACL-private-subnet.id
  count          = length(local.private_subnets)
  subnet_id      = element(aws_subnet.private.*.id, count.index)

}

data "aws_network_acls" "NACL-default" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.service_name}-NACL-default"
  }
}

resource "aws_vpc_dhcp_options" "dhcp" {
  enable_dhcp_options              = true
  domain_name         = "service.consul"
  domain_name_servers = ["127.0.0.1", "10.10.0.2"]

  tags = {
    Name = "${var.service_name}-dhcp"
  }
}
resource "aws_vpc_dhcp_options_association" "dhcp-association" {
  vpc_id          = aws_vpc.main.id
  dhcp_options_id = aws_vpc_dhcp_options.dhcp.id
}