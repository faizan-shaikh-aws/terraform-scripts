  # CREATE EC2 INSTANCE
  resource "tls_private_key" "pvt_key" {
    algorithm = "RSA"
  }
  resource "local_file" "private_key" {
    filename = "/home/faizan/aws_keys/ebs_key.pem"
    content = tls_private_key.pvt_key.private_key_pem
  }
  resource "aws_key_pair" "ebs_key" {
    key_name="ebs_key"
    public_key = tls_private_key.pvt_key.public_key_openssh
  }
  resource "aws_instance" "Database" {
    ami = "ami-0b5eea76982371e91"
    instance_type = "t2.micro"
    key_name = aws_key_pair.ebs_key.key_name
    root_block_device {
      volume_type = "gp3"
      volume_size = 11
    }
    tags = {
      "Name" = "EBS_Demo"
    }
  }

  # CREATE EBS VOLUME
  resource "aws_ebs_volume" "EBS_Volume" {
    size = 7
    type = "io1"
    iops = 101
    availability_zone = aws_instance.Database.availability_zone
  }

  # ATTACH EBS VOLUMNE
  resource "aws_volume_attachment" "Attach_Volume" {
    device_name = "/dev/sdf"
    instance_id = aws_instance.Database.id
    volume_id = aws_ebs_volume.EBS_Volume.id
  }

