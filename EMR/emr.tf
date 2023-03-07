provider "aws" {
  region = "us-east-1"
}

/*
terraform {
  backend "s3" {
    bucket  = "emr-automation"
    key     = "output/emrstate.tfstate"
    region  = "us-east-1"
  }
}*/


resource "aws_emr_cluster" "cluster" {
  name           = "Terraform-Automation_5"
  release_label  = "emr-6.2.0"
  applications   = [ "Hadoop", "Hive", "Hue", "JupyterHub", "Pig", "Presto", "Spark"]
  termination_protection = false  
  autoscaling_role ="arn:aws:iam::806722281598:role/EMR_AutoScaling_DefaultRole"
  configurations_json = file("configuration.json.tpl")
  log_uri      = "s3://emr-automation-123/emr-logs/"
  service_role = "arn:aws:iam::806722281598:role/EMR_DefaultRole"



  step_concurrency_level = 1


  ec2_attributes {
    key_name                          = "terraform.pem"
    subnet_id                         = "subnet-010db33fc603d81b6"
    emr_managed_master_security_group = "sg-0b31bbc90a1100d73"
    emr_managed_slave_security_group  = "sg-0ad2848f8a1412e5e"
    #service_access_security_group = "sg-0226c16857dbe338a"
    instance_profile               = "EMR_EC2_DefaultRole"
  }


master_instance_group { 
      name           = "MasterGroup"
      instance_type  = "m5.xlarge"
      instance_count = 1
      bid_price      = "0.3"    
      ebs_config {
                    iops = null
                    size = 30
                    type = "gp2"
                    volumes_per_instance = 1
                    }


}


core_instance_group {
  
      name           = "CoreGroup"
      instance_type  = "m5.xlarge"
      instance_count = "1"
      bid_price      = "0.3"    #Do not use core instances as Spot Instance in Prod because terminating a core instance risks data loss.
      ebs_config {
                    iops = null
                    size = 30
                    type = "gp2"
                    volumes_per_instance = 1
                    }
      autoscaling_policy = file("core_instance_group-autoscaling_policy.json.tpl")
}
 
  tags = {
    Name        = "Terraform-Automation"
    Project     = "emr-automation-123"
    Environment = "dev"


  }
}


resource "aws_emr_instance_group" "task_instance_group" {
  
      name           = "taskGroup"
      cluster_id = join("", aws_emr_cluster.cluster.*.id)
      instance_type  = "m5.xlarge"
      instance_count = 1
      bid_price      = "0.3"    #Spot Instances are preferred  in Prod
      configurations_json = file("configuration.json.tpl")
      autoscaling_policy = file("task_instance_group-autoscaling_policy.json.tpl")
      ebs_config {
                    iops = null
                    size = 30
                    type = "gp2"
                    volumes_per_instance = 1
                    }       
}