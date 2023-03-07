data "aws_iam_policy_document" "EMR_AssumeRole" {
    statement {
    effect = "Allow"
    principals {
      type = "Service"
      identifiers = ["elasticmapreduce.amazonaws.com"]
    }
      actions = ["sts:AssumeRole"]
    }
}
resource "aws_iam_role" "EMR_Role" {
  name = "EMR_Role_Terraform"
  assume_role_policy = data.aws_iam_policy_document.EMR_AssumeRole.json
}
resource "aws_iam_role_policy_attachment" "EMR_Role_Attach" {
  role = aws_iam_role.EMR_Role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonElasticMapReduceRole"
}

data "aws_iam_policy_document" "EMR_EC2_AssumeRole" {
  statement {
    effect = "Allow"
    principals {
        type = "Service"
        identifiers = ["ec2.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}
resource "aws_iam_role" "EMR_EC2_Role" {
  name = "EMR_EC2_Role_Terraform"
  assume_role_policy = data.aws_iam_policy_document.EMR_EC2_AssumeRole.json
}
resource "aws_iam_role_policy_attachment" "EMR_EC2_RoleAttach" {
  role = aws_iam_role.EMR_EC2_Role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonElasticMapReduceforEC2Role"
}
resource "aws_iam_instance_profile" "emr_ec2_instance_profile1" {
  name = aws_iam_role.EMR_Role.name
  role = aws_iam_role.EMR_EC2_Role.name
}

