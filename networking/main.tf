# networking/main.tf

// assigning it to VPCs
resource "random_integer" "random" {
  min = 1
  max = 100
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "random_shuffle" "az_list" {
  input        = data.aws_availability_zones.available.names
  result_count = var.max_subnets
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc
resource "aws_vpc" "proxy_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "proxy_vpc-${random_integer.random.id}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_subnet" "proxy_public_subnet" {
  count                   = var.public_sn_count
  vpc_id                  = aws_vpc.proxy_vpc.id
  cidr_block              = var.public_cidrs[count.index]
  map_public_ip_on_launch = true
  // round-robin all availability zones
  availability_zone = random_shuffle.az_list.result[count.index]

  tags = {
    // subnets generally start the numbering from 1
    Name = "proxy_public_sn_${count.index + 1}"
  }
}

// every public subnet created will have an association with the public rt
resource "aws_route_table_association" "proxy_public_assoc" {
  count          = var.public_sn_count
  subnet_id      = aws_subnet.proxy_public_subnet.*.id[count.index]
  route_table_id = aws_route_table.proxy_rt.id
}

resource "aws_internet_gateway" "proxy-igw" {
  vpc_id = aws_vpc.proxy_vpc.id

  tags = {
    Name = "proxy-igw"
  }
}

resource "aws_route_table" "proxy_rt" {
  vpc_id = aws_vpc.proxy_vpc.id

  tags = {
    Name = "proxy_rt"
  }
}

// default route to igw
resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.proxy_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.proxy-igw.id
}

// http, https, ssh, proxy ports ingress, open for egress
resource "aws_security_group" "proxy_sg" {
  vpc_id      = aws_vpc.proxy_vpc.id
  for_each    = var.security_groups
  name        = each.value.name
  description = each.value.description

  dynamic "ingress" {
    for_each = each.value.ingress
    content {
      from_port = ingress.value.from
      to_port   = ingress.value.to
      protocol  = ingress.value.protocol
      // plural mostly means list
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  egress {
    from_port = 0
    to_port   = 0
    // -1 is all protocols
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

