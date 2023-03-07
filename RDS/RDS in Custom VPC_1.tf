resource "aws_db_instance" "mysql-db" {
  identifier = "mysql-cluster-1"
  name = "db_name"
  allocated_storage = 27
  storage_type = "gp2"
  #iops = 100
  instance_class = "db.m4.large"
  engine = "mysql"
  engine_version = "5.7"
  username = "admin"
  password = "admin123"
  parameter_group_name = "default.mysql5.7"
  db_subnet_group_name = aws_db_subnet_group.db_sub_grp.id
  vpc_security_group_ids = [ data.aws_security_group.get_SG.id ]
}

output "getDBSubGrp" {
  value = aws_db_subnet_group.db_sub_grp.id
}

output "getSubnet" {
  value = data.aws_subnet_ids.available_subnets.ids
}

output "getSG" {
  value = data.aws_security_group.get_SG.id
}

