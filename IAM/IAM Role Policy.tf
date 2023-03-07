/*
Create IAM role and attach the Policies to it
Refer data_policy files
*/

resource "aws_iam_policy" "First_Policy" {
  name = "Faizan_Policy_1"
  path = "/"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:Describe*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_policy" "Second_Policy" {
  name = "Faizan_Policy_2"
  path = "/"
  policy = data.aws_iam_policy_document.PolicyDoc.json
}

resource "aws_iam_role" "My_Role" {
  name = "Faizan_Role"
  assume_role_policy = data.aws_iam_policy_document.MyPolicy_Assume.json
}

resource "aws_iam_role_policy_attachment" "Attach" {
  role = aws_iam_role.My_Role.name
  policy_arn = aws_iam_policy.First_Policy.arn
}


