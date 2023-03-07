/*
Create a Simple instance & attach a public key
*/
resource "tls_private_key" "pvt_pub_keys" {
    algorithm = "RSA" 
}
resource "local_file" "aws_connect_tf" {
  content = tls_private_key.pvt_pub_keys.private_key_pem
  filename = "/home/faizan/aws_keys/aws_connect_tf.pem"
}
resource "aws_key_pair" "public_key" {
  key_name = "aws_connect_tf"
  public_key = tls_private_key.pvt_pub_keys.public_key_openssh
}

resource "aws_instance" "MyFirst" {
    ami = "ami-0b5eea76982371e91"
    instance_type = "t2.micro"
    key_name = aws_key_pair.public_key.key_name
}



