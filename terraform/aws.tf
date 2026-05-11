resource "aws_s3_bucket" "immich_backup" {
  bucket = "immich-${var.aws_account_id}-ap-northeast-3-an"
}

resource "aws_iam_user" "terraform" {
  name = "terraform"
}

resource "aws_iam_user" "immich_backup" {
  name = "immich-backup"
}

resource "aws_iam_user" "kazuki" {
  name = "kazuki"
}

data "aws_iam_policy_document" "terraform_execution" {
  statement {
    sid = "AllowCallerIdentity"

    actions = [
      "sts:GetCallerIdentity",
    ]

    resources = ["*"]
  }

  statement {
    sid = "AllowS3BucketManagement"

    actions = [
      "s3:ListBucket",
      "s3:GetBucketLocation",
      "s3:GetBucketVersioning",
      "s3:PutBucketVersioning",
      "s3:GetBucketPolicy",
      "s3:PutBucketPolicy",
      "s3:DeleteBucketPolicy",
      "s3:GetBucketTagging",
      "s3:PutBucketTagging",
      "s3:DeleteBucketTagging",
    ]

    resources = [aws_s3_bucket.immich_backup.arn]
  }

  statement {
    sid = "AllowS3ObjectManagement"

    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject",
      "s3:ListBucketMultipartUploads",
      "s3:AbortMultipartUpload",
      "s3:ListMultipartUploadParts",
    ]

    resources = ["${aws_s3_bucket.immich_backup.arn}/*"]
  }

  statement {
    sid = "AllowTerraformUserManagement"

    actions = [
      "iam:GetUser",
      "iam:ListAccessKeys",
      "iam:ListUserPolicies",
      "iam:PutUserPolicy",
      "iam:DeleteUserPolicy",
      "iam:CreateAccessKey",
      "iam:DeleteAccessKey",
    ]

    resources = [aws_iam_user.terraform.arn]
  }
}

resource "aws_iam_user_policy" "terraform_execution" {
  name   = "terraform-execution"
  user   = aws_iam_user.terraform.name
  policy = data.aws_iam_policy_document.terraform_execution.json
}

data "aws_iam_policy_document" "immich_backup_s3" {
  statement {
    sid = "AllowS3ListBucketMultipartUploads"

    actions = [
      "s3:ListBucketMultipartUploads",
    ]

    resources = [aws_s3_bucket.immich_backup.arn]
  }

  statement {
    sid = "AllowS3PutObjectAndMultipart"

    actions = [
      "s3:PutObject",
      "s3:AbortMultipartUpload",
      "s3:ListMultipartUploadParts",
    ]

    resources = ["${aws_s3_bucket.immich_backup.arn}/*"]
  }
}

resource "aws_iam_user_policy" "immich_backup_s3" {
  name   = "immich-backup-s3"
  user   = aws_iam_user.immich_backup.name
  policy = data.aws_iam_policy_document.immich_backup_s3.json
}
