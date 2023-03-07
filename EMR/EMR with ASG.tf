resource "aws_emr_cluster" "RAN0" {
  name = "RAN0-HDP"
  release_label = "emr-6.2.0"
  applications = ["spark", "hive", "hue", "presto"]
  log_uri = "s3://edlhp1-data.s3.amazonaws.com/EMR-Logs/"
  service_role = "arn:aws:iam::806722281598:role/EMR_DefaultRole"
  autoscaling_role = "arn:aws:iam::806722281598:role/EMR_AutoScaling_DefaultRole"
  configurations_json = file("configuration.json.tpl")
  termination_protection = false

    ec2_attributes {
      key_name = "terraform1"
      subnet_id = "subnet-010db33fc603d81b6"
      emr_managed_master_security_group = "sg-0b31bbc90a1100d73"
      emr_managed_slave_security_group = "sg-0ad2848f8a1412e5e"
      instance_profile = "EMR_EC2_DefaultRole"
    }

    master_instance_group {
      name = "MasterGroup"
      instance_type = "m5.xlarge"
      instance_count = 1
      bid_price = 1
      ebs_config {
        type = "gp2"
        size = "13"
        volumes_per_instance = 1
      }
    }

    core_instance_group {
      name = "SlaveGroup"
      instance_type = "m5.xlarge"
      instance_count = 2
      bid_price = 1
      autoscaling_policy = file("core_instance_group-autoscaling_policy.json.tpl")
      ebs_config {
        type = "gp2"
        size = 17
        volumes_per_instance = 1
      }
    }
}

resource "aws_emr_instance_group" "name" {
  name = "TaskGroup"
  cluster_id = aws_emr_cluster.RAN0.id
  instance_type = "m5.xlarge"
  autoscaling_policy = file("task_instance_group-autoscaling_policy.json.tpl")
      instance_count = 2
      bid_price = 1
      ebs_config {
        type = "gp2"
        size = 17
        volumes_per_instance = 1
      }
}