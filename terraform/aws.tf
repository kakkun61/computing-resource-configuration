resource "aws_s3_bucket" "immich_backup" {
  bucket = "immich-${var.aws_account_id}-ap-northeast-3-an"
}

resource "aws_s3_bucket_versioning" "immich_backup" {
  bucket = aws_s3_bucket.immich_backup.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "immich_backup" {
  bucket = aws_s3_bucket.immich_backup.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "immich_backup" {
  bucket = aws_s3_bucket.immich_backup.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_ownership_controls" "immich_backup" {
  bucket = aws_s3_bucket.immich_backup.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "immich_backup" {
  bucket = aws_s3_bucket.immich_backup.id

  rule {
    id     = "immich-backup-lifecycle"
    status = "Enabled"

    filter {
      prefix = ""
    }

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = 90
      storage_class = "GLACIER"
    }

    noncurrent_version_transition {
      noncurrent_days = 30
      storage_class   = "STANDARD_IA"
    }

    noncurrent_version_transition {
      noncurrent_days = 90
      storage_class   = "GLACIER"
    }

    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }
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
      "s3:GetLifecycleConfiguration",
      "s3:PutLifecycleConfiguration",
      "s3:DeleteLifecycleConfiguration",
      "s3:GetBucketPublicAccessBlock",
      "s3:PutBucketPublicAccessBlock",
      "s3:DeleteBucketPublicAccessBlock",
      "s3:GetEncryptionConfiguration",
      "s3:PutEncryptionConfiguration",
      "s3:DeleteBucketEncryption",
      "s3:GetBucketOwnershipControls",
      "s3:PutBucketOwnershipControls",
      "s3:DeleteBucketOwnershipControls",
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
      "s3:ListBucket",
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
