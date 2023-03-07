resource "aws_emr_cluster" "Hadoop-CDP" {
  name = "Hadoop_CDP"
  release_label = "emr-6.2.0"
  applications = ["Hadoop", "Spark", "Hue", "Hive", "Presto"]
  log_uri = "s3://emr-automation-123/emr-logs/"
  service_role = "arn:aws:iam::806722281598:role/EMR_Role_Terraform"
  termination_protection = false
  # custom_ami_id = ""

  ec2_attributes {
    key_name = "terraform.pem"
    subnet_id = "subnet-02701028c8fac5bab"
    instance_profile = "EMR_Role_Terraform"
    emr_managed_master_security_group = "sg-04f79dffc15e19422"
    emr_managed_slave_security_group = "sg-085292042eb71e4dc"
  }

  master_instance_group {
    name="MaterGrp-TF"
    instance_type = "m5.xlarge"
    instance_count = 1
    bid_price = 0.3
    ebs_config {
      size = 30
      type = "gp2"
      iops = null
      volumes_per_instance = 1
    }
  }

  core_instance_group {
    name="Slave-TF"
    instance_type = "m5.xlarge"
    instance_count = 4
    bid_price = 0.3
    ebs_config {
      size = 30
      type = "gp2"
      iops = null
      volumes_per_instance = 1
    }
  }
  /*provisioner "local-exec" {
    command = "echo ${aws_emr_cluster.Hadoop-CDP.public_ip}"
  }*/


}

resource "aws_emr_instance_group" "TaskNodes" {
    name = "TaskNodes"
    cluster_id = aws_emr_cluster.Hadoop-CDP.id  
    instance_type = "m5.xlarge"
    instance_count = 2
    bid_price = 0.3
    ebs_config {
      size = 30
      type = "gp2"
      iops = null
      volumes_per_instance = 1
    }
}