resource "aws_iam_user" "velero" {
  name = "velero"
  path = "/system/"
  tags = {
    name = "Velero backup for EKS Demo cluster"
  }

}

resource "aws_iam_access_key" "velero" {
  user    = aws_iam_user.velero.name
#   pgp_key = "keybase:velero"
}


resource "aws_iam_user_policy" "velero_backup" {
    name = "velero-backup"
    user = aws_iam_user.velero.id
    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ec2:DescribeVolumes",
                "ec2:DescribeSnapshots",
                "ec2:CreateTags",
                "ec2:CreateVolume",
                "ec2:CreateSnapshot",
                "ec2:DeleteSnapshot"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:DeleteObject",
                "s3:PutObject",
                "s3:AbortMultipartUpload",
                "s3:ListMultipartUploadParts"
            ],
            "Resource": [
                "arn:aws:s3:::velero-backup-demo-eks1347/*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket"
            ],
            "Resource": [
                "arn:aws:s3:::velero-backup-demo-eks1347"
            ]
        }
    ]
}
EOF

}

resource "aws_iam_role" "velero" {
  name               = "velero_role"
  assume_role_policy = file("${path.module}/policies/velero-role.json")
}

resource "aws_iam_role_policy" "velero" {
  name     = "velero_policy"
  policy   = file("${path.module}/policies/velero-policy.json")
  role     = aws_iam_role.velero.id
}

