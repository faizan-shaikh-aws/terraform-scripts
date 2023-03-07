resource "tls_private_key" "pvt_pub_key" {
  algorithm = "RSA"
}
resource "local_file" "pvt_key" {
  filename = "/home/faizan/aws_keys/aws_connect.pem"
  content = tls_private_key.pvt_pub_key.private_key_pem
}
resource "aws_key_pair" "pub_key" {
  key_name = "aws_connect"
  public_key = tls_private_key.pvt_pub_key.public_key_openssh
}

resource "aws_instance" "webserver" {
  ami = "ami-0b5eea76982371e91"
  instance_type = "t2.micro"
  tags = {
    "Name" = "Webserver"
  }
  key_name = aws_key_pair.pub_key.key_name
  vpc_security_group_ids = [aws_security_group.ssh_access_new.id]
}

resource "aws_security_group" "ssh_access_new" {
  name = "Allow only ssh_access_new"
  description = "My first SG"
  ingress{
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "sgID"{
    value = aws_security_group.ssh_access_new.id
}