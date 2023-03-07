resource "aws_vpc" "MyVPC" {
  cidr_block = "10.0.0.0/16"
  tags = {
    "Name" = "RAN0-VPC"
  }
}

resource "aws_subnet" "publicSub" {
    vpc_id = aws_vpc.MyVPC.id
    count = length(var.az)
    cidr_block = element(var.public_subets, count.index)
    availability_zone = element(var.az, count.index)
    tags = {
      "Name" = "Public Subnet - ${count.index + 1}"
    }
}

resource "aws_subnet" "privateSub" {
  vpc_id = aws_vpc.MyVPC.id
  count = length(var.private_subnets)
  availability_zone = element(var.az, count.index)
  cidr_block = element(var.private_subnets, count.index)

  tags = {
    "Name" = "Private Subnet - ${count.index + 1}"
  }
}

# IGW
resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.MyVPC.id
  tags = {
    "Name" = "RAN0-IGW"
  }
}

# ROUTE
resource "aws_route_table" "PubRouteTable" {
  vpc_id = aws_vpc.MyVPC.id
  tags = {
    "Name" = "RAN0-RT-Public"
  }
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IGW.id
  } 
}

resource "aws_route_table" "PriRouteTable" {
  vpc_id = aws_vpc.MyVPC.id
  tags = {
    "Name" = "RAN0-RT-Private"
  }
  route {
    cidr_block = "192.168.0.1/32"
    gateway_id = aws_internet_gateway.IGW.id
  }
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.MyNatGW.id
  }
}

# List Private/Public Subnets
data "aws_subnets" "PubSubnets" {
  filter {
    name = "vpc-id"
    values = [aws_vpc.MyVPC.id]
  }
  filter {
    name = "tag:Name"
    values = ["*Public*"]
  }
}
data "aws_subnets" "PriSubnets" {
  filter {
    name = "vpc-id"
    values = [aws_vpc.MyVPC.id]
  }
  filter {
    name = "tag:Name"
    values = ["*Private*"]
  }
}

/*
resource "local_file" "count1" {
  count = length(data.aws_subnets.PubSubnets.ids)
  filename = "/home/faizan/vpc/count"
  #content = element(data.aws_subnets.PubSubnets.ids, count.index)

}
*/
# Subnet Associate with Route Table

resource "aws_route_table_association" "PubRTAsso" {
  count = length(data.aws_subnets.PubSubnets.ids)
  route_table_id = aws_route_table.PubRouteTable.id
  subnet_id = element(data.aws_subnets.PubSubnets.ids, count.index)
}

resource "aws_route_table_association" "PriRTAsso" {
  route_table_id = aws_route_table.PriRouteTable.id
  count = length(var.private_subnets)
  subnet_id = element(aws_subnet.privateSub[*].id, count.index)
}

# NAT Gateway

data "aws_subnet" "getPub1" {
  filter {
    name = "vpc-id"
    values = [aws_vpc.MyVPC.id]
  }
  filter {
    name = "tag:Name"
    values = ["Public Subnet - 1"]
  }

}
resource "aws_eip" "myEIP" {
  vpc = true
}

resource "aws_nat_gateway" "MyNatGW" {
  subnet_id = data.aws_subnets.getPub1.id
  allocation_id = aws_eip.myEIP.id
  tags = {
    "Name" = "RAN0-NATGW"
  }
}



