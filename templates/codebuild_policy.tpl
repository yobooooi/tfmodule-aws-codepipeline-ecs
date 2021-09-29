{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Resource": [
          "*"
        ],
        "Action": [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "ecr:GetAuthorizationToken",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload",
          "ecr:BatchCheckLayerAvailability",
          "ecr:PutImage",
          "ecs:RunTask",
          "iam:PassRole"
        ]
      },
      {
        "Effect":"Allow",
        "Action": [
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:GetBucketVersioning",
          "s3:List*",
          "s3:PutObject"
        ],
        "Resource": "*"
      },
      {
        "Effect": "Allow",
        "Action": [
          "ec2:CreateNetworkInterface",
          "ec2:DescribeDhcpOptions",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DeleteNetworkInterface",
          "ec2:DescribeSubnets",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeVpcs"
        ],
        "Resource": "*"
      },
      {
        "Effect": "Allow",
        "Action": [
          "ec2:CreateNetworkInterfacePermission"
        ],
        "Resource": [
          "arn:aws:ec2:${aws_region}:${aws_account_id}:network-interface/*"
        ],
        "Condition": {
          "StringEquals": {
            "ec2:Subnet": [
              "arn:aws:ec2:${aws_region}:${aws_account_id}:subnet/${subnet_id1}",
              "arn:aws:ec2:${aws_region}:${aws_account_id}:subnet/${subnet_id2}",
              "arn:aws:ec2:${aws_region}:${aws_account_id}:subnet/${subnet_id3}"
            ],
            "ec2:AuthorizedService": "codebuild.amazonaws.com"
          }
        }
      },
      {
        "Effect": "Allow",
        "Action":[
          "ssm:GetParametersByPath",
          "ssm:GetParameters",
          "ssm:GetParameter"
        ],
        "Resource":[
          "arn:aws:ssm:${aws_region}:${aws_account_id}:parameter/${service_name}/*",
          "arn:aws:ssm:${aws_region}:${aws_account_id}:parameter/codebuild/*"
        ]
      },
      {
        "Effect": "Allow",
        "Action":[
          "kms:Decrypt",
          "kms:GenerateDataKey"
        ],
        "Resource":[
          "*"
        ]
      }
    ]
  }