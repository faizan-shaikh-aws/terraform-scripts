resource "tls_private_key" "oskey" {
  algorithm = "RSA"
}

resource "local_file" "myterrakey" {
  content  = tls_private_key.oskey.private_key_pem
  filename = "myterrakey.pem"
}

resource "aws_key_pair" "key121" {
  key_name   = "myterrakey"
  public_key = tls_private_key.oskey.public_key_openssh
}

output "pub" {
  value = "aws_key_pair.key121.key_name"
}


resource "aws_instance" "mytfinstance" {
  ami           = "ami-0b5eea76982371e91"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.key121.key_name


}
