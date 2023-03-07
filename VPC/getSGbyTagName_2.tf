data "aws_vpc" "getVPC"{
    filter {
      name = "tag:Name"
      values = ["Default"]
    }

}

data "aws_security_group" "getSG" {
    filter {
      name = "tag:Name"
      values = ["*Project*"]
    }
    filter {
      name = "vpc-id"
      values = ["${data.aws_vpc.getVPC.id}"]
    }
}

output "getVPC" {
  value = data.aws_vpc.getVPC.id
}

output "getSGname" {
  value = data.aws_security_group.getSG.id
}


