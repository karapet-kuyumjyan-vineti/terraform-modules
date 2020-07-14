############################
#S3 Buckets Replication Role
############################

resource "aws_iam_role" "s3-replication" {
  name               = "AWSRoleS3replicaion-${var.client_name}"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "s3.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
POLICY
}

##############################
#S3 Buckets Replication Policy
##############################

resource "aws_iam_policy" "s3-replication-policy" {
  depends_on = [aws_iam_role.s3-replication]
  name       = "AWSRolePolicyReplication-${var.client_name}"
  policy     = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:GetReplicationConfiguration",
        "s3:ListBucket"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_s3_bucket.signature-documents-primary.arn}"
      ]
    },
    {
      "Action": [
        "s3:GetObjectVersion",
        "s3:GetObjectVersionAcl",
        "s3:GetObjectVersionForReplication"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_s3_bucket.signature-documents-primary.arn}/*"
      ]
    },
    {
      "Action": [
        "s3:ReplicateObject",
        "s3:ReplicateDelete",
        "s3:ReplicateTags",
        "s3:GetObjectVersionTagging"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_s3_bucket.signature-documents-dr.arn}/*"
      ]
    }
  ]
}
POLICY
}

#########################################
#S3 Buckets Replication Policy Attachment
#########################################

resource "aws_iam_policy_attachment" "replication" {
  depends_on = [aws_iam_role.s3-replication]
  name       = "AWSPolicyAttachmentS3Replication-${var.client_name}"
  roles      = [aws_iam_role.s3-replication.name]
  policy_arn = aws_iam_policy.s3-replication-policy.arn
}