resource "aws_db_instance" "protgres-sql-db" {
    identifier = "protgres-sql-db"
    db_name = "main_db"
    instance_class = "db.t2.micro"
    storage_type = "gp2"
    allocated_storage = 23
    engine = "postgres"
    engine_version = "12.9"
    username = "faizansk"
    password = "Storm1993"
    parameter_group_name = aws_db_parameter_group.rds-postgre-pg_new.id
    backup_retention_period = 8
    storage_encrypted = true

    vpc_security_group_ids = [ data.aws_security_group.getSG.id ]
    db_subnet_group_name = aws_db_subnet_group.mergePrivateSubnets.id

}

resource "aws_db_snapshot" "create_DB_SS" {
  db_instance_identifier = aws_db_instance.protgres-sql-db.id
  db_snapshot_identifier = "Snopshot-22ndJan-2023"
}

provider "aws" {
  region = "us-east-2"
  alias = "replica"
}
resource "aws_db_instance_automated_backups_replication" "automated_replica" {
  source_db_instance_arn = aws_db_instance.protgres-sql-db.arn

  provider = "aws.replica"
}