#spark-submit --class org.apache.spark.examples.SparkPi /usr/lib/spark/examples/jars/spark-examples_2.12-3.0.1-amzn-0.jar 10
# GENERAL CONFIGS
name = "(Optional) Friendly name given to the instance group."
configurations_json = "(Optional) JSON string for supplying list of configurations for the EMR cluster."
autoscaling_role = "(Optional) IAM role for automatic scaling policies. The IAM role provides permissions that the automatic scaling feature requires to launch and terminate EC2 instances in an instance group."
log_uri = "(Optional) Path to the Amazon S3 location where logs for this cluster are stored."
service_role = "(Required) IAM role that will be assumed by the Amazon EMR service to access AWS resources."
step_concurrency_level = "(Optional) Number of steps that can be executed concurrently. You can specify a maximum of 256 steps. Only valid for EMR clusters with release_label 5.28.0 or greater (default is 1)."
keep_job_flow_alive_when_no_steps = "(Optional) Switch on/off run cluster with no steps or when all steps are complete (default is on)"
custom_ami_id = "(Optional) Custom Amazon Linux AMI for the cluster (instead of an EMR-owned AMI). Available in Amazon EMR version 5.7.0 and later."

# EC2 ATTRIBUTES
ec2_attributes = "(Optional) Attributes for the EC2 instances running the job flow. See below."
emr_managed_master_security_group = "(Optional) Identifier of the Amazon EC2 EMR-Managed security group for the master node."
emr_managed_slave_security_group = "(Optional) Identifier of the Amazon EC2 EMR-Managed security group for the slave nodes."
service_access_security_group = "(Optional) Identifier of the Amazon EC2 service-access security group - required when the cluster runs on a private subnet."
instance_profile = "(Required) Instance Profile for EC2 instances of the cluster assume this role. We can attach a Role to an EC2 instance through Instance Profile"
subnet_id = "(Optional) VPC subnet id where you want the job flow to launch"
subnet_ids = "(Optional) List of VPC subnet id-s where you want the job flow to launch. Amazon EMR identifies the best Availability Zone to launch instances according to your fleet specifications"

# MASTER_INSTANCE_GROUP / CORE_INSTANCE_GROUP
name_ = "(Optional) Friendly name given to the instance group."
master_instance_fleet = "Optional) Configuration block to use an Instance Fleet for the master node type. Cannot be specified if any master_instance_group configuration blocks are set."
master_instance_group = "(Optional) Configuration block to use an Instance Group for the master node type."
core_instance_group = "(Optional) Configuration block to use an Instance Group for the core node type."
autoscaling_policy = "(Optional) String containing the EMR Auto Scaling Policy JSON."
instance_count = "For Multi master, value should be 3, default is 1"

# AWS EMR INSTANCE GROUP (TASK NODES)
aws_emr_instance_group = "Provides an Elastic MapReduce Cluster Instance Group configuration."
cluster_id = "(Required) ID of the EMR Cluster to attach to. Changing this forces a new resource to be created."

# USE GLUE IN EMR CLUSTER
/*
1) Create a configuration.json.tpl with the following content 
[{
       "Classification": "spark-hive-site",
       "Properties": {
         "hive.metastore.client.factory.class": "com.amazonaws.glue.catalog.metastore.AWSGlueDataCatalogHiveClientFactory"
       }
     }
]

2) Create a template from the above template in your terraform code
data "template_file" "cluster_1_configuration" {
  template = "${file("${path.module}/templates/configuration.json.tpl")}"
}

3) Add the template in EMR config.tf
configurations = "${data.template_file.cluster_1_configuration.rendered}"
*/









