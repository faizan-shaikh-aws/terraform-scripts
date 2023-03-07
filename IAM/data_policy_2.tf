data "aws_iam_policy_document" "PolicyDoc" {
    statement {
    sid = "1"

    actions = [
      "s3:ListAllMyBuckets",
      "s3:GetBucketLocation",
    ]

    resources = [
      "arn:aws:s3:::*",
    ]
  }

  statement {
    actions = [
      "s3:ListBucket",
    ]

    resources = [
      "arn:aws:s3:::edlhp1-data",
    ]

    condition {
      test     = "StringLike"
      variable = "s3:prefix"

      values = [
        "",
        "home/",
        "home/&goku/",
      ]
    }
  }
}

data "aws_iam_policy_document" "MyPolicy_Assume" {
  statement {
    effect = "Allow"
    principals {
      type = "Service"
      identifiers = ["elasticmapreduce.amazonaws.com"]
    }
      actions = ["sts:AssumeRole"]
    }
}
