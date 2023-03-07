resource "aws_security_group" "ssh_access_new" {
  name = "Allow only ssh_access_new"
  description = "My first SG for RDS"
  vpc_id = aws_vpc.main.id
  tags = {
    "name" = "RDS SG"
    "value" = "RDS Security Group"
  }
  ingress{
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}