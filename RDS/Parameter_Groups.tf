resource "aws_db_parameter_group" "rds-postgre-pg_new" {
  name = "rds-postgre-pg"
  family = "postgres12"

    parameter {
      name = "application_name"
      value = "faizan"
    }
    parameter {
      name = "archive_timeout"
      value = 313
    }
    parameter {
      name = "autovacuum_naptime"
      value = 17
    }
    parameter {
      name = "checkpoint_timeout"
      value = 37
    }
}