resource "aws_db_instance" "mysql-prod-db" {
  identifier = "mysql-prod-db"
  db_name = "EDLHP1"
  deletion_protection = false
  multi_az = true

  engine = "mysql"
  engine_version = "5.7"

  username = "admin"
  password = "admin1234"

  allocated_storage = 29
  storage_type = "gp2"
  instance_class = "db.m4.large"
  storage_encrypted = true

  skip_final_snapshot = true
  backup_window = "18:00-21:00"
  backup_retention_period = 33
  maintenance_window = "Sat:21:35-Sat:23:55"

  parameter_group_name = aws_db_parameter_group.mysql-prod-pg.id
  vpc_security_group_ids = [ data.aws_security_group.getSG.id ]
  db_subnet_group_name = aws_db_subnet_group.getDBSunetgrp.id

}

resource "aws_db_snapshot" "mysql-prod-db-SS" {
    db_instance_identifier = aws_db_instance.mysql-prod-db.id
    db_snapshot_identifier = "Snapshot-22ndJan-2023"
}

resource "aws_db_instance_automated_backups_replication" "mysql-prod-db-replica" {
  kms_key_id = "aws/rds"
  source_db_instance_arn = aws_db_instance.mysql-prod-db.arn
  provider = "aws.mumbai"
}

resource "aws_db_parameter_group" "mysql-prod-pg" {
    name = "mysql-prod-pg"
    family = "mysql5.7"

  /*parameter {
    name = "log_error"
    value = "/hdplogs/mysql/mysql-error.log"
  }
  parameter {
    name = "general_log_file"
    value = "/hdplogs/mysql/general-error.log"
  }*/
  parameter {
    name = "lock_wait_timeout"
    value = 313
  }
}