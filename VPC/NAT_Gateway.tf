data "aws_vpc" "main" {
    filter {
      name = "tag:Name"
      values = ["*Project VPC*"]
    }
}

data "aws_subnet" "getPubSubnet" {
    filter {
      name = "vpc-id"
      values = [ data.aws_vpc.main.id ]
    }
    filter {
      name = "tag:Name"
      values = [ "Public Subnet - 1" ]
    }
}

data "aws_subnet" "getPriSubnet" {
    filter {
      name = "vpc-id"
      values = [ data.aws_vpc.main.id ]
    }
    filter {
      name = "tag:Name"
      values = [ "Private Subnet - 1" ]
    }
}

/*
output "getPubSubnet" {
  value = data.aws_subnet.getPubSubnet.id
}
*/

resource "aws_eip" "nat_gateway_EIP" {
  vpc = true
}

resource "aws_nat_gateway" "MyNATGW" {
    allocation_id = aws_eip.nat_gateway_EIP.id
    subnet_id = data.aws_subnet.getPubSubnet.id
    tags = {
      "Name" = "Nat-Gateway-TF"
    }    
}

output "getNGW" {
  value = aws_eip.nat_gateway_EIP.public_ip
}

resource "aws_route_table" "RouteTableNGW" {
  vpc_id = data.aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.MyNATGW.id
  }
}

resource "aws_route_table_association" "AssoNGW" {
  route_table_id = aws_route_table.RouteTableNGW.id
  subnet_id = data.aws_subnet.getPriSubnet.id
}

data "aws_key_pair" "ec2-key" {
  key_name = "new-demo"
}

resource "aws_instance" "Nat_instance" {
  ami = "ami-0b5eea76982371e91"
  instance_type = "t2.micro"
  vpc_security_group_ids = ["sg-09045ef01911c9377"]
  subnet_id = "subnet-0622aca1f4048f9c0"
  associate_public_ip_address = true
  key_name = data.aws_key_pair.ec2-key.key_name
}

/*
data "aws_subnets" "getPrivateSubnet" {
    filter {
      name = "vpc-id"
      values = [ data.aws_vpc.main.id ]
    }
    filter {
      name = "tag:Name"
      values = ["*Private*"]
    }
}

output "getPrivate" {
  value = data.aws_subnets.getPrivateSubnet.ids
}
*/
