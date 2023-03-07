/*
Create EC2 instance Webserver, in given AZs & capture its public IPS.
Also attach EBS volumes to the Servers
Additionally, create TLS private/public keys.
*/



resource "tls_private_key" "pvt_keys" {
  algorithm = "RSA"
}
resource "local_file" "get_pem" {
  filename = "/tmp/webserver_key"
  content = tls_private_key.pvt_keys.private_key_pem
}
resource "aws_key_pair" "key_pair" {
  key_name = "webserver_key"
  public_key = tls_private_key.pvt_keys.public_key_openssh
}


variable "list_AZ" {
  type = list(string)
  description = "List of Availability Zones"
  default = [ "us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d", "us-east-1e", "us-east-1f"]
}
variable "instance_count" {
  type = number
  default = 6
}

resource "aws_instance" "WebServer" {
  count = var.instance_count
  ami = "ami-0b5eea76982371e91"
  instance_type = "t2.micro"
  key_name = "terraform"
  #key_name = aws_key_pair.key_pair.key_name
  availability_zone = element(var.list_AZ, count.index)
  user_data = file("/home/faizan/terraform/webserver.sh")
  root_block_device {
    volume_type = "gp2"
    volume_size = 11
  }
  tags = {
    "Name" = "Instance - ${count.index + 1}"
    "Department" = "Science"
  }

  provisioner "local-exec" {
    command = "echo ${self.public_ip} >> /tmp/ips.txt"    
  }

}

resource "aws_ebs_volume" "MyEBS" {
  count = var.intance_coinstance_countunt
  type = "io1"
  size = 17
  iops = 101
  availability_zone = aws_instance.WebServer[count.index].availability_zone
  tags = {
    "Name" = "${aws_instance.WebServer[count.index].id}"
  }
}

resource "aws_volume_attachment" "attach" {
  count = var.instance_count
  device_name = "/dev/xvdn"
  instance_id = aws_instance.WebServer[count.index].id
  volume_id = aws_ebs_volume.MyEBS[count.index].id
}


