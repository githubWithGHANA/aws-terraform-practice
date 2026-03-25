###############################################################
#FE-ASG
resource "aws_autoscaling_group" "frontend_asg" {

  name             = "nit-dev-fe-asg"
  desired_capacity = 1
  min_size         = 1
  max_size         = 1

  vpc_zone_identifier = [
    aws_subnet.private_1.id,
    aws_subnet.private_2.id
  ]

  target_group_arns = [
    aws_lb_target_group.fe_tg.arn
  ]

  launch_template {
    id      = aws_launch_template.frontend_lt.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "nit-dev-fe-asg-instance"
    propagate_at_launch = true
  }
}

# BE-AUTO SCALING GROUP
# desired=1, min=1, max=2
###############################################################

resource "aws_autoscaling_group" "be_asg" {
  name                = "nit-dev-be-asg"
  desired_capacity    = 1
  min_size            = 1
  max_size            = 1
  vpc_zone_identifier = [aws_subnet.private_1.id, aws_subnet.private_2.id]
  target_group_arns   = [aws_lb_target_group.be_tg.arn]

  launch_template {
    id      = aws_launch_template.be_lt.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "nit-dev-be-asg-instance"
    propagate_at_launch = true
  }
  depends_on = [
    aws_s3_object.backend_app,
    aws_ssm_parameter.mysql_host,
    aws_ssm_parameter.mysql_username,
    aws_ssm_parameter.mysql_password
  ]
}

#Lifecycle-hooks
resource "aws_autoscaling_lifecycle_hook" "be_launch_hook" {

  name                   = "nit-be-launch-hook"
  autoscaling_group_name = aws_autoscaling_group.be_asg.name
  lifecycle_transition   = "autoscaling:EC2_INSTANCE_LAUNCHING"

  heartbeat_timeout = 300
  default_result    = "CONTINUE"
}

#scheduling

resource "aws_autoscaling_schedule" "scale_up_morning" {

  scheduled_action_name  = "scale-up-morning"
  autoscaling_group_name = aws_autoscaling_group.be_asg.name

  desired_capacity = 2
  min_size         = 1
  max_size         = 2

  recurrence = "0 9 * * *"
}

resource "aws_autoscaling_schedule" "scale_down_night" {

  scheduled_action_name  = "scale-down-night"
  autoscaling_group_name = aws_autoscaling_group.be_asg.name

  desired_capacity = 1
  min_size         = 1
  max_size         = 1

  recurrence = "0 22 * * *"
}