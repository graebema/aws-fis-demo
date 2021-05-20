# test git hook
resource "aws_iam_role" "ec2-role" {
  name               = "ec2-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": "ec2AssumeRole"
    }
  ]
}
EOF

}

# instance profile which allows ssm and cloudwatch log creation

resource "aws_iam_instance_profile" "ec2-role-instanceprofile" {
  name = "ec2-role-instanceprofile"
  role = aws_iam_role.ec2-role.name
}

resource "aws_iam_role_policy" "ec2-role-policy" {
  name   = "ec2-role-policy"
  role   = aws_iam_role.ec2-role.id
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
              "logs:CreateLogStream",
              "logs:DescribeLogStreams",
              "logs:CreateLogGroup",
              "logs:PutLogEvents"
            ],
            "Resource": [
              "*"
            ]
        }
    ]
}
EOF

}

resource "aws_iam_role_policy_attachment" "ec2-role-ssm-attach" {
  role       = aws_iam_role.ec2-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
