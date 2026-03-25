# SECURITY GROUPS
###############################################################

# 1. ALB SG — accepts HTTP 80 from internet
resource "aws_security_group" "alb_sg" {
  name        = "nit-dev-alb-sg"
  description = "Allow HTTP 80 from internet"
  vpc_id      = aws_vpc.nit_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "nit-dev-alb-sg" }
}

# 2. FE SG — accepts 8501 from ALB SG
resource "aws_security_group" "fe_sg" {
  name        = "nit-dev-fe-sg"
  description = "Allow 8501 from ALB SG"
  vpc_id      = aws_vpc.nit_vpc.id

  ingress {
    from_port       = 8501
    to_port         = 8501
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "nit-dev-fe-sg" }
}

# 3. NLB SG — reference only, NLB (TCP) does not attach SGs
resource "aws_security_group" "nlb_sg" {
  name        = "nit-dev-nlb-sg"
  description = "Allow 80 from FE SG (reference only)"
  vpc_id      = aws_vpc.nit_vpc.id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.fe_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "nit-dev-nlb-sg" }
}

# 4. BE SG — accepts 8084 from private subnet CIDRs
# NLB uses subnet IPs directly for health checks & traffic
resource "aws_security_group" "be_sg" {
  name        = "nit-dev-be-sg"
  description = "Allow 8084 from NLB private subnet CIDRs"
  vpc_id      = aws_vpc.nit_vpc.id

  ingress {
    from_port   = 8084
    to_port     = 8084
    protocol    = "tcp"
    cidr_blocks = [
    aws_subnet.private_1.cidr_block,
    aws_subnet.private_2.cidr_block
  ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "nit-dev-be-sg" }
}

# 5. RDS SG — accepts 3306 from BE SG only
resource "aws_security_group" "rds_sg" {
  name        = "nit-dev-rds-sg"
  description = "Allow MySQL 3306 from BE SG only"
  vpc_id      = aws_vpc.nit_vpc.id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.be_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "nit-dev-rds-sg" }
}