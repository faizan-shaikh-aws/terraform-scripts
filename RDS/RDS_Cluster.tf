resource "aws_rds_cluster" "cluster1" {
  cluster_identifier = "edl"
  availability_zones = ["us-east-1b", "us-east-1d", "us-east-1f"]
  engine = "aurora-mysql"
  #engine_mode = "multimaster"
  engine_version = "5.7.mysql_aurora.2.11.1"
  master_username = "admin"
  master_password = "123456789"
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.clusterPG.id
}

resource "aws_rds_cluster_instance" "getInst" {
  count = 2
  identifier = "prod${count.index + 1}"
  cluster_identifier = aws_rds_cluster.cluster1.id
  instance_class = "db.r4.large"
  engine = aws_rds_cluster.cluster1.engine
  engine_version = aws_rds_cluster.cluster1.engine_version
  
}

resource "aws_rds_cluster_parameter_group" "clusterPG" {
  name = "tryitout"
  family = "aurora-mysql5.7"
  parameter {
    name = "binlog_cache_size"
    value = 9999
  }
}


/*****************/
resource "aws_rds_cluster" "cluster" {
  cluster_identifier = "ran02"
  engine = "aurora-mysql"
  engine_version = "5.7.mysql_aurora.2.11.1"
  availability_zones = ["us-east-1b", "us-east-1d", "us-east-1f"]
  database_name = "EDLHP1"
  master_username = "admin"
  master_password = "1234567890"
  /*db_cluster_instance_class = "db.t2.small"
  allocated_storage         = 11*/
}

resource "aws_rds_cluster_instance" "instances" {
  count = 3
  identifier = "ran0-edlhp${count.index + 1}"
  cluster_identifier = aws_rds_cluster.cluster.id
  instance_class = "db.r4.large"
  engine = aws_rds_cluster.cluster.engine
  engine_version = aws_rds_cluster.cluster.engine_version


}





