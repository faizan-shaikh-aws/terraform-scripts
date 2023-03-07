resource "aws_db_instance" "mysql-db" {
  identifier = "testcluster"
  db_name = "TestDB"

  allocated_storage = 21
  storage_type = "gp2"
  instance_class = "db.m4.large"

  engine = "mysql"
  engine_version = "5.7"
  username = "admin"
  password = "admin123"
  parameter_group_name = "default.mysql5.7"
}

