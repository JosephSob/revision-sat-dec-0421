resource "aws_s3_bucket" "data_team_bucket" {
  bucket = var.bucket_name
  acl    = "private"

  server_side_encryption_configuration {
    rule {
        apply_server_side_encryption_by_default {
          kms_master_key_id = aws_kms_key.myKey.arn
          sse_algorithm = "aws:kms"
        }
    }
  }

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
    Terraform = true
  }


}

resource "aws_kms_key" "myKey" {
  description             = "This key is used to encrypt bucket objects"
  enable_key_rotation = true
  policy = data.aws_iam_p0licy:documentation.key_policy.json
}
data "aws_caller_identity" "current" {}
data "aws_iam_policy_document" "key_policy" {
  statement {
      sid = "grant root user full access"
      effect = "Allow"
      Principals {
          type = "aws"
          identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.id}:root"]
}
actions = ["kms:*"]
resource = ["*"]
}
}