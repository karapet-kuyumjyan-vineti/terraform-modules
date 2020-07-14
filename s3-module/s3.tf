######################################
#S3 Bucket Signature Documents Primary
######################################

resource "aws_s3_bucket" "signature-documents-primary" {
  bucket = "signature-documents-${var.client_name}-${var.env}"
  region = var.primary_region
  acl    = "private"

  replication_configuration {
    role = aws_iam_role.s3-replication.arn
    rules {
      status = "Enabled"
      destination {
        bucket = aws_s3_bucket.signature-documents-dr.arn
        storage_class = "STANDARD"
      }
    }
  }

  versioning {
    enabled = true
  }

  lifecycle_rule {
    id      = "lifecycle"
    enabled = true

    transition {
      days          = 90
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = 180
      storage_class = "GLACIER"
    }

    expiration {
      days = 10950
    }
  }
}



resource "aws_s3_bucket" "signature-documents-dr" {
  bucket   = "signature-documents-${var.client_name}-${var.env}-dr"
  acl      = "private"
  region   = var.dr_region
  provider = aws.dr


  versioning {
    enabled = true
  }

  lifecycle_rule {
    id      = "lifecycle"
    enabled = true

    transition {
      days          = 90
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = 180
      storage_class = "GLACIER"
    }

    expiration {
      days = 10950
    }
  }
}