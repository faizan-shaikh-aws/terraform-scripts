resource "aws_db_instance" "mySQL_DB" {
  identifier = "rdslake"
  db_name = "EDLHP1"
  multi_az = true
  deletion_protection = false

  engine = "mysql"
  engine_version = "5.7"

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

resource "aws_db_snapshot" "snapshot" {
  db_instance_identifier = aws_db_instance.mySQL_DB.id
  db_snapshot_identifier = "ran0-mysql-snapshot"
}

provider "aws" {
  region = "us-east-2"
  alias = "mumbai"
}

resource "aws_db_instance_automated_backups_replication" "Backup" {
  kms_key_id = "arn:aws:kms:us-east-2:806722281598:key/c3f92587-5ef9-4746-b754-937cb351a758"
  source_db_instance_arn = aws_db_instance.mySQL_DB.arn
  provider = "aws.mumbai"
}

resource "aws_db_parameter_group" "name" {
  name = "ran0-paramgrp-1"
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
  name = "ran0 - subnet group - 1"
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