resource "aws_iam_policy" "FirstPolicyFile" {
  name = "FirstPolicyFile"
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

resource "aws_iam_policy" "CreatePolicyWithData" {
  name = "CreatePolicyWithData"
  path = "/"
  policy = data.aws_iam_policy_document.CreatePolicyDoc.json
}