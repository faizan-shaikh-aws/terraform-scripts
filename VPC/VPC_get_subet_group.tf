data "aws_vpc" "get_vpc" {
  filter {
    name   = "tag:Name"
    values = ["Project VPC"]
  }
}

data "aws_subnets" "available_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.get_vpc.id]
  }
  filter {
    name   = "tag:Name"
    values = ["*Public*"]
  }
}

resource "aws_db_subnet_group" "db_sub_grp" {
  name       = "main"
  subnet_ids = data.aws_subnets.available_subnets.ids
  tags = {
    Name = "My DB subnet grp"
  }
}

output "getVPC" {
  value = data.aws_vpc.get_vpc.id
}
output "available_subnets" {
  value = data.aws_subnets.available_subnets.ids
}
output "getDBgrp" {
  value = aws_db_subnet_group.db_sub_grp.id
}

/*
OUTPUT

getDBgrp = toset([
  "subnet-0874611b105fd1913",
  "subnet-0c901fbf1fe2fcb00",
  "subnet-0fb518ed5d5a27262",
])
getGrp = toset([
  "subnet-0874611b105fd1913",
  "subnet-0c901fbf1fe2fcb00",
  "subnet-0fb518ed5d5a27262",
])
getVPC = "vpc-0c30482ee4d550f84"


*/

/* OLD ONE
data "aws_subnet_ids" "available_subnets" {
  vpc_id = data.aws_vpc.get_vpc.id
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.get_vpc.id]
  }
  filter {
    name   = "tag:Name"
    values = ["*Public*"]
  }
}*/