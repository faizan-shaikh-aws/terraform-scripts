data "aws_vpc" "main" {
  filter {
    name = "tag:Name"
    values = ["Default"]
  }
}
resource "aws_security_group" "EMR_Master_SG" {
  name = "EMR-Master-Security-Group-TF"
  vpc_id = data.aws_vpc.main.id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 4040
    to_port = 4040
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    to_port = 8888
    from_port = 8888
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    to_port = 20888
    from_port = 20888
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    to_port = 0
    from_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "EMR_Slave_SG" {
  name = "EMR-Slave-Security-Group-TF"
  vpc_id = data.aws_vpc.main.id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "TCP"
    security_groups = [aws_security_group.EMR_Master_SG.id]
    # cidr_blocks = [aws_security_group.EMR_Master_SG.id]
  }

    egress {
    to_port = 0
    from_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
    
}

output "vpc" {
  value = data.aws_vpc.main.id
}
output "master-sg" {
  value = aws_security_group.EMR_Master_SG.id
}