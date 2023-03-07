# CREATE VPC
resource "aws_vpc" "main"{
    cidr_block = "10.0.0.0/16"
    tags = {
      "Name" = "Project VPC"
    }
}

#CREATE SUBNET & ASSIGN IT TO DIFFERENT AZs
variable "azs" {
  type = list(string)
  default = [ "us-east-1a", "us-east-1b", "us-east-1c" ]
}
variable "public_subnet_cidrs" {
  type = list(string)
  description = "Public Subnet CIDR values"
  default = [ "10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24" ]
}
variable "private_subnet_cidrs" {
  type = list(string)
  description = "Private Subnet CIDR values"
  default = [ "10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24" ]
}

resource "aws_subnet" "public_subnets" {
  count = length(var.public_subnet_cidrs)
  vpc_id = aws_vpc.main.id
  cidr_block = element(var.public_subnet_cidrs, count.index)
  availability_zone = element(var.azs, count.index)
  tags = {
    "Name" = "Public Subnet - ${count.index + 1}"
  }
}

resource "aws_subnet" "private_subnets" {
  count = length(var.private_subnet_cidrs)
  vpc_id = aws_vpc.main.id
  cidr_block = element(var.private_subnet_cidrs, count.index)
  availability_zone = element(var.azs, count.index)
  tags = {
    "Name" = "Private Subnet - ${count.index + 1}"
  }
}

#INTERNET GATEWAY
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
  tags = {
    "Name" = "Project VPC IG"
  }
}

# ROUTE TABLE
resource "aws_route_table" "second_rt" {
  vpc_id = aws_vpc.main.id
  tags = {
    "Name" = "2nd Route Table"
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

#Associate Public Subnet with Second Route Table
resource "aws_route_table_association" "public_subnet_asso" {
  count = length(var.public_subnet_cidrs)
  subnet_id = element(aws_subnet.public_subnets[*].id, count.index)
  route_table_id = aws_route_table.second_rt.id
}

# Create Subnet Group
data "aws_subnet_ids" "public_subnet_id" {
  vpc_id = aws_vpc.main.id
  filter {
    name = "tag:Name"
    values = ["Public*"]
  }
}
data "aws_subnet_ids" "private_subnet_id" {
  vpc_id = aws_vpc.main.id
  filter {
    name = "tag:Name"
    values = ["Private*"]
  }
}

output "getPubSubnet" {
  value = "data.aws_subnet_ids.public_subnet_id.ids"
}
output "getPvtSubnet" {
  value = "data.aws_subnet_ids.private_subnet_id.ids"
}