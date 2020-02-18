# VPC
resource "aws_vpc" "vik-vpc" {
  cidr_block           = "10.0.0.0/16" # R -> IP range of the VPC
  instance_tenancy     = "default"     # O -> EC2 tenancy - shared(default)/dedicated
  enable_dns_support   = "true"        # O -> enables dns support in VPC. Defaults true.
  enable_dns_hostnames = "true"        # O -> enables dns hostnames in VPC. Defaults false.
  enable_classiclink   = "false"       # O -> enable/disable ClassicLink DNS Support for the VPC. Only valid in regions and accounts that support EC2 Classic. Defaults false.

  # ClassicLink allows you to link an ec2-classic instance to a VPC in your account, within the same region. 
  # ec2-classic instance is a instance running in a single, flat network that is shared with other customers(opposite to VPC)

  tags = {
    Name    = "vik-vpc"
    Comment = "Created from terraform"
  }
}

# Subnets
# public subnets
resource "aws_subnet" "vik-publicsubnet-1" {
  vpc_id                  = "${aws_vpc.vik-vpc.id}"
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = "true"       # O -> True for public subnet. Default is false.
  availability_zone       = "eu-west-1a" # O -> The AZ for the subnet.
}

resource "aws_subnet" "vik-publicsubnet-2" {
  vpc_id                  = "${aws_vpc.vik-vpc.id}"
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "eu-west-1b"
}

resource "aws_subnet" "vik-publicsubnet-3" {
  vpc_id                  = "${aws_vpc.vik-vpc.id}"
  cidr_block              = "10.0.3.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "eu-west-1b"
}

# private subnets
resource "aws_subnet" "vik-privatesubnet-1" {
  vpc_id                  = "${aws_vpc.vik-vpc.id}"
  cidr_block              = "10.0.4.0/24"
  map_public_ip_on_launch = "false" # O -> False for public subnet. Default is false.
  availability_zone       = "eu-west-1a"
}

resource "aws_subnet" "vik-privatesubnet-2" {
  vpc_id                  = "${aws_vpc.vik-vpc.id}"
  cidr_block              = "10.0.5.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "eu-west-1b"
}

resource "aws_subnet" "vik-privatesubnet-3" {
  vpc_id                  = "${aws_vpc.vik-vpc.id}"
  cidr_block              = "10.0.6.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "eu-west-1c"
}

# Internet gateway -> Public subnets need to be connected to IGW for internet access
resource "aws_internet_gateway" "vik-igw" {
  vpc_id = "${aws_vpc.vik-vpc.id}"
}

# Route tables -> Only for public subnets. Useful for Internet access
resource "aws_route_table" "vik-public-rt" {
  vpc_id = "${aws_vpc.vik-vpc.id}"

  route {
    cidr_block = "0.0.0.0/0" # All IPs except the one matches the VPC range will be routed to IGW
    gateway_id = "${aws_internet_gateway.vik-igw.id}"
  }
}

# route associations public - associating the subnets
#NOTE: Please note that one of either subnet_id or gateway_id is required.
#The following arguments are supported:
#subnet_id - (Optional) The subnet ID to create an association. Conflicts with gateway_id.
#gateway_id - (Optional) The gateway ID to create an association. Conflicts with subnet_id.
#route_table_id - (Required) The ID of the routing table to associate with.

resource "aws_route_table_association" "vik-public-1a" {
  subnet_id      = "${aws_subnet.vik-publicsubnet-1.id}"
  route_table_id = "${aws_route_table.vik-public-rt.id}"
}

resource "aws_route_table_association" "vik-public-1b" {
  subnet_id      = "${aws_subnet.vik-publicsubnet-2.id}"
  route_table_id = "${aws_route_table.vik-public-rt.id}"
}

resource "aws_route_table_association" "vik-public-1c" {
  subnet_id      = "${aws_subnet.vik-publicsubnet-3.id}"
  route_table_id = "${aws_route_table.vik-public-rt.id}"
}

