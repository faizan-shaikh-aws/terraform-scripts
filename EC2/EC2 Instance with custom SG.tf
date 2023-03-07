

#READ RESOURCE FROM AWS INFRA
data "aws_key_pair" "console_key_read" {
    key_name = "terraform.pem"
}

# CREATE EC2 INSTANCE
resource "aws_instance" "webserver_public" {
  ami = "ami-0b5eea76982371e91"
  instance_type = "t2.micro"
  tags = {
    "Name" = "Webserver-Public"
  }

  user_data = "${file("webserver.sh")}"
/*
  user_data = <<-EOF
  #!/bin/bash
  sudo yum update;
  sudo yum install httpd -y;
  sudo systemctl enable httpd; 
  sudo systemctl start httpd;
  EOF
*/
  key_name = data.aws_key_pair.console_key_read.key_name
  vpc_security_group_ids = [aws_security_group.WebAccess.id]
}

#CREATE SG
resource "aws_security_group" "WebAccess" {
  name = "WebServer Internet Access"
  description = "Allow HTTP, SSH and ICMP access"
  ingress{
    from_port = 22
    to_port = 22
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress{
    from_port = 80
    to_port = 80
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress{
    from_port = 443
    to_port = 443
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress{
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}