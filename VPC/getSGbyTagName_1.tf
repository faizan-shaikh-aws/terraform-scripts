data "aws_vpc" "get_vpc" {
  filter {
    name   = "tag:Name"
    values = ["Project VPC"]
  }
}

data "aws_security_group" "get_SG" {
  filter {
    name   = "vpc-id"
    values = ["${data.aws_vpc.get_vpc.id}"]
  }
  filter {
    name   = "description"
    values = ["*RDS*"]
  }
}

output "getSG" {
  value = data.aws_security_group.get_SG.id
}

/*
getSG = "sg-012e37a1be6bbc439"
https://docs.aws.amazon.com/cli/latest/reference/ec2/describe-security-groups.html
*/