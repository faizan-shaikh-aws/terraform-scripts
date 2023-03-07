resource "aws_db_instance" "mutiaz" {
  identifier = "multiaz"
  db_name = "EDLHP1"
  multi_az = true
  deletion_protection = false

  engine = "mysql"
  engine_version = "5.7"
  availability_zones      = ["us-east-1a", "us-east-1b", "us-east-1c"]

  username = "admin"
  password = "admin12345"

  allocated_storage = 23
  storage_type = "gp2"
  instance_class = "db.m4.large"
  storage_encrypted = true

  skip_final_snapshot = false
  backup_window = "18:00-21:00"
  backup_retention_period = "21"
  maintenance_window = "Sat:21:35-Sat:23:55"

  db_subnet_group_name = aws_db_subnet_group.SubGrp.id
  vpc_security_group_ids = [data.aws_security_group.getSG.id]
}


resource "aws_db_parameter_group" "name" {
  name = "ran0-paramgrp-2"
  family = "mysql5.7"
  parameter {
    name = "lock_wait_timeout"
    value = 313
  }
  parameter {
    name = "connect_timeout"
    value = 786
  }
}

data "aws_vpc" "main" {
  filter {
    name =  "tag:Name"
    values = ["*RAN0*"]
  }
}
data "aws_subnets" "getSubnets" {
  filter {
    name = "vpc-id"
    values = [data.aws_vpc.main.id]
  }
  filter {
    name = "tag:Name"
    values = ["*Public*"]
  }
}

resource "aws_db_subnet_group" "SubGrp" {
  name = "ran0 - subnet group - 2"
  subnet_ids = data.aws_subnets.getSubnets.ids
}

data "aws_security_group" "getSG" {
  filter {
    name = "vpc-id"
    values = [data.aws_vpc.main.id]
  }
  filter {
    name = "tag:Name"
    values = ["MySQL"]
  }
}