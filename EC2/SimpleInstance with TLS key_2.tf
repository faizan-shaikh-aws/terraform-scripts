resource "tls_private_key" "pvt_pub_keys" {
  algorithm = "RSA"
}

resource "local_file" "private_key" {
  filename = "/home/faizan/aws_keys/aws_connect2.pem"
  content = tls_private_key.pvt_pub_keys.private_key_pem
}

resource "aws_key_pair" "public_key" {
    key_name = "aws_connect2"
    public_key = tls_private_key.pvt_pub_keys.public_key_openssh
}

resource "aws_instance" "Ubuntu" {
  ami = "ami-00874d747dde814fa"
  instance_type = "t2.micro"
  key_name = aws_key_pair.public_key.key_name
  tags = {
    "Name" = "Ubuntu"
    "Description" = "Demo EC2 Instance"
  }
}

