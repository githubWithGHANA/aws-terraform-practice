#Frontend alb and tg
resource "aws_lb" "frontend_alb" {
  name               = "nit-dev-fe-alb"
  internal           = false
  load_balancer_type = "application"

  security_groups = [aws_security_group.alb_sg.id]

  subnets = [
    aws_subnet.public_1.id,
    aws_subnet.public_2.id
  ]

  tags = {
    Name = "nit-dev-fe-alb"
  }
}

#fe-tg
resource "aws_lb_target_group" "fe_tg" {
  name     = "nit-dev-fe-tg"
  port     = 8501
  protocol = "HTTP"
  vpc_id   = aws_vpc.nit_vpc.id

  health_check {
    path     = "/"
    port     = "8501"
    protocol = "HTTP"
  }

  tags = {
    Name = "nit-dev-fe-tg"
  }
}
resource "aws_lb_listener" "alb_listener" {

  load_balancer_arn = aws_lb.frontend_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {

    type             = "forward"
    target_group_arn = aws_lb_target_group.fe_tg.arn
  }
}
#Backend nlb and target group
resource "aws_lb" "nlb" {

  name               = "nit-dev-nlb"
  internal           = true
  load_balancer_type = "network"

  subnets = [
    aws_subnet.private_1.id,
    aws_subnet.private_2.id
  ]

  tags = {
    Name = "nit-dev-nlb"
  }
}

resource "aws_lb_target_group" "be_tg" {

  name        = "nit-dev-be-tg"
  port        = 8084
  protocol    = "TCP"
  vpc_id      = aws_vpc.nit_vpc.id
  target_type = "instance"

  health_check {
   # path     = "/actuator"     #IMP
    protocol = "TCP"
    port     = "8084"
  }
}

resource "aws_lb_listener" "nlb_listener" {

  load_balancer_arn = aws_lb.nlb.arn
  port              = 80
  protocol          = "TCP"

  default_action {

    type             = "forward"
    target_group_arn = aws_lb_target_group.be_tg.arn
  }
}