/*TO CHECK
IAM, VPC, SG, EBS
*/

resource "aws_emr_cluster" "cluster" {
  # Name, release name, applications, log uri, tags


  ec2_attributes {
    # keyname, subnet id, master/slave SG, instance profile
  }


master_instance_group { 
      # name, instance type, instance count, bid price, EBS config {}
  }


core_instance_group {  
      # name, instance type, instance count, bid price, EBS config, auto scale json
  }

}

resource "aws_emr_instance_group" "task_instance_group" {
       # name, instance type, instance count, bid price, EBS config   
}

/*
service_role : 
Role : AmazonElasticMapReduceRole
We've to provide an IAM Role to EMR so that it can access other AWS services like ASG, EC2, S3, CW, SQS, SimpleDB, IAM.
Without this permission, we cannot provision a cluster





*/