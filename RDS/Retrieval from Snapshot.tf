

resource "aws_db_instance" "db_test" {
instance_class = "db.t2.small"
identifier = "newtestdb"
username = "test"
password = "Test@54132"
publicly_accessible = false
#db_subnet_group_name = "${aws_db_subnet_group.db-subnet.name}"
#vpc_security_group_ids = ["sg-00h62b79"]
skip_final_snapshot = true

snapshot_identifier = "${data.aws_db_snapshot.db_snapshot.id}"

}


data "aws_db_snapshot" "db_snapshot" {
most_recent = true
db_snapshot_identifier  = "demoss"
}

output "getSS" {
  value = data.aws_db_snapshot.db_snapshot.id
}