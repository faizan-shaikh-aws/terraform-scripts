data "aws_vpc" "main" {
    filter {
        name = "tag:Name"
        values = ["Project VPC"]
    }
}
data "aws_subnets" "getSubnetList" {
    filter {
        name = "vpc-id"
        values = [data.aws_vpc.main.id]
    }
    filter {
      name = "tag:Name"
      values = ["Private*"]
    }
}
resource "aws_db_subnet_group" "mergePrivateSubnets" {
  name = "db-private-subnet-group"
  subnet_ids = data.aws_subnets.getSubnetList.ids
}
data "aws_security_group" "getSG" {
    filter {
      name = "vpc-id"
      values = [data.aws_vpc.main.id]
    }
    filter {
      name = "description"
      values = ["My first SG for RDS"]
    }
    filter {
      name = "group-name"
      values = ["Allow only ssh_access_new"]
    }
}
output "getVPC" {
  value = data.aws_vpc.main.id
}
output "getSubnets" {
    value = data.aws_subnets.getSubnetList.ids
}
output "getDBsubnet" {
  value = aws_db_subnet_group.mergePrivateSubnets.id
}
output "getSGname" {
  value = data.aws_security_group.getSG.id
}

