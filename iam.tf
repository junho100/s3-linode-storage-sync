module "s3_readonly_iam_user" {
  source = "terraform-aws-modules/iam/aws//modules/iam-user"

  name        = "s3-readonly-user-for-sync"
  policy_arns = [aws_iam_policy.s3_readonly_iam_policy.arn]
}

resource "aws_iam_policy" "s3_readonly_iam_policy" {
  name        = "s3-readonly-policy"
  description = "s3 readonly policy"
  policy = templatefile("./files/s3-readonly-policy.json.tftpl", {
    s3_arn = data.aws_s3_bucket.src_bucket.arn
  })
}

