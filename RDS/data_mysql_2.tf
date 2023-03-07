data "aws_vpc" "main" {
  filter {
    name = "tag:Name"
    values = ["Project VPC"]
  }
  filter {
    name = "owner-id"
    values = ["806722281598"]
  }
}

data "aws_subnets" "getPubSubnet" {
    filter {
      name = "vpc-id"
      values = [data.aws_vpc.main.id]
    }
    filter {
      name = "tag:Name"
      values = ["Public*"]
    }
}

resource "aws_db_subnet_group" "getDBSunetgrp" {
  name = "mysql-prod-db-subnet-group"
  subnet_ids = data.aws_subnets.getPubSubnet.ids
}

data "aws_security_group" "getSG" {
    filter {
      name = "vpc-id"
      values = [data.aws_vpc.main.id]
    }
    filter {
      name = "description"
      values = ["*RDS*"]
    }
    filter {
      name = "group-name"
      values = ["Allow only ssh_access_new"]
    }
}

output "getVPC" {
  value = data.aws_vpc.main.id
}
output "getPubSubnet" {
  value = data.aws_subnets.getPubSubnet.ids
}
output "getDBSubetgrp" {
  value = aws_db_subnet_group.getDBSunetgrp.id
}
output "getSG_name" {
  value = data.aws_security_group.getSG.id
}
