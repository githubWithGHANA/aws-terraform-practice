#Frontend
resource "aws_iam_role" "frontend_role" {
  name = "nit-dev-fe-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = "sts:AssumeRole"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })

  tags = {
    Name = "nit-dev-fe-role"
  }
}

resource "aws_iam_role_policy_attachment" "fe_s3" {
  role       = aws_iam_role.frontend_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role_policy_attachment" "fe_ssm" {
  role       = aws_iam_role.frontend_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "frontend_profile" {
  name = "nit-dev-fe-instance-profile"
  role = aws_iam_role.frontend_role.name
}

# IAM — Custom Parameter Policy Backend
# Matches exactly: /nit/dev/* paths used in userdata
###############################################################

resource "aws_iam_policy" "parameter_policy" {
  name        = "my-nit-parameter-policy"
  description = "Allow EC2 to read /nit/dev/* SSM parameters"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "ssm:GetParameter",
        "ssm:GetParameters",
        "ssm:GetParametersByPath",
        "ssm:GetParameterHistory"
      ]
      Resource = "arn:aws:ssm:ap-south-1:*:parameter/nit/dev/*"
    }]
  })
}

###############################################################
# IAM — Role & Instance Profile
###############################################################

resource "aws_iam_role" "be_role" {
  name = "nit-dev-be-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })

  tags = { Name = "nit-dev-be-role" }
}

resource "aws_iam_role_policy_attachment" "rds_full" {
  role       = aws_iam_role.be_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonRDSDataFullAccess"
}

resource "aws_iam_role_policy_attachment" "s3_full" {
  role       = aws_iam_role.be_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role_policy_attachment" "ssm_core" {
  role       = aws_iam_role.be_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "cw_agent" {
  role       = aws_iam_role.be_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_role_policy_attachment" "param_policy" {
  role       = aws_iam_role.be_role.name
  policy_arn = aws_iam_policy.parameter_policy.arn
}

resource "aws_iam_instance_profile" "be_profile" {
  name = "nit-dev-be-instance-profile"
  role = aws_iam_role.be_role.name
}

