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

data "aws_security_group" "get_SG" {
  # vpc_id = data.aws_vpc.get_vpc.id

  filter {
    name   = "vpc-id"
    values = ["${data.aws_vpc.get_vpc.id}"]
  }

  filter {
    name = "description"
    values = ["*RDS*"]
  }

  filter {
    name   = "group-name"
    values = ["*Allow only ssh_access_new"]
  }

}




/*
output "getVPC" {
  value = data.aws_vpc.get_vpc.id
}
output "getSG" {
  value = data.aws_security_group.get_SG.id
}

/*
getSG = "sg-012e37a1be6bbc439"
https://docs.aws.amazon.com/cli/latest/reference/ec2/describe-security-groups.html
*/
