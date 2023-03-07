resource "aws_emr_cluster" "Titan" {
  name = "Titan-HDP"
  release_label = "emr-6.2.0"
  applications = ["Hadoop", "Hive", "Spark", "Hue"]
  log_uri = "s3://emr-automation-123/emr-logs/"
  service_role = "arn:aws:iam::806722281598:role/EMR_DefaultRole"
  termination_protection = false

  ec2_attributes {
    key_name = "terraform.pem"
    subnet_id = "subnet-010db33fc603d81b6"
    emr_managed_master_security_group = "sg-0b31bbc90a1100d73"
    emr_managed_slave_security_group = "sg-0ad2848f8a1412e5e"
    instance_profile = "EMR_EC2_DefaultRole"
  }

  master_instance_group {
    name = "MasterGroup"
    instance_type = "m5.xlarge"
    instance_count = 1
    bid_price = 0.3
    ebs_config {
      type = "gp2"
      size = 30
      iops = null
      volumes_per_instance = 1
    }

  }

  core_instance_group {
    name = "CoreGroup"
    instance_type = "m5.xlarge"
    instance_count = 2
    bid_price = 3
    ebs_config {
        type = "gp2"
        size = "30"
        iops = null
        volumes_per_instance = 1
    }
  }

  tags = {
    name = "titan"
    environment = "HDP"
  }

}

resource "aws_emr_instance_group" "TaskNodes" {
  name = "TaskNodes"
  cluster_id = aws_emr_cluster.Titan.id
  instance_type = "m5.xlarge"
  instance_count = 2
  bid_price = 0.3
    ebs_config {
        type = "gp2"
        size = "30"
        iops = null
        volumes_per_instance = 1
    }

}