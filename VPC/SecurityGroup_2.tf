data "aws_vpc" "get_VPC" {
    filter {
      name = "tag:Name"
      values = ["Project*"]
    }
}
output "getVPC" {
  value = data.aws_vpc.get_VPC.id
}

resource "aws_security_group" "getSG" {
  name = "Allow HTTPS access"
  vpc_id = data.aws_vpc.get_VPC.id
  tags = {
    "Name" = "Allow HTTPS access"
  }
  
  ingress {
    protocol = "tcp"
    from_port = 443
    to_port = 443
    cidr_blocks = ["192.168.1.1/32"]
  }
  ingress {
    protocol = "tcp"
    from_port = "3306"
    to_port = "3306"
    cidr_blocks = ["192.168.1.1/32"]
    description = "MySQL Access"
  }
  egress {
    protocol = "-1"
    from_port = 0
    to_port = 0
    cidr_blocks = ["192.168.1.1/32"]
    description = "All Traffic anywhere"
  }
}