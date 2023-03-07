# https://developer.hashicorp.com/terraform/tutorials/aws/aws-rds

/* CREATE RDS INSTANCE */
resource "aws_db_instance" "education" {
  identifier             = "education"
  instance_class         = "db.t3.micro"
  allocated_storage      = 5
  engine                 = "postgres"
  engine_version         = "14.1"
  username               = "edu"
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.education.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  parameter_group_name   = aws_db_parameter_group.education.name
  publicly_accessible    = true
  skip_final_snapshot    = true
}

/* CREATE A READ REPLICA DB THAT REFERENCES ABOVE RDS DB - ADD REPLICATE PARAM */
resource "aws_db_instance" "education_replica" {
   name                   = "education-replica"
   identifier             = "education-replica"
   instance_class         = "db.t3.micro"
   apply_immediately      = true
   publicly_accessible    = true
   skip_final_snapshot    = true
   vpc_security_group_ids = [aws_security_group.rds.id]
   parameter_group_name   = aws_db_parameter_group.education.name

   replicate_source_db    = aws_db_instance.education.identifier
}

# replicate_source_db : Specifies that this resource is a Replicate database, and to use this value as the source database



