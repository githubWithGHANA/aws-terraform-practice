#FE-LT
resource "aws_launch_template" "frontend_lt" {

  name          = "nit-dev-fe-lt"
  image_id      = "ami-051a31ab2f4d498f5"
  instance_type = "t3.micro"
  key_name      = "akshay1"

  iam_instance_profile {
    name = aws_iam_instance_profile.frontend_profile.name
  }

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [aws_security_group.fe_sg.id]
  }

  user_data = base64encode(
    templatefile("${path.module}/fe-userdata.sh", {
      backend_dns = aws_lb.nlb.dns_name
    })
  )

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "nit-dev-fe-instance"
    }
  }

  tags = {
    Name = "nit-dev-fe-lt"
  }

  depends_on = [
    aws_s3_object.frontend_app,
    aws_lb.nlb
  ]
}

# BE-LAUNCH TEMPLATE
###############################################################

resource "aws_launch_template" "be_lt" {
  name          = "nit-dev-be-lt"
  image_id      = "ami-051a31ab2f4d498f5"
  instance_type = "t3.micro"
  key_name      = "akshay1"

  iam_instance_profile {
    name = aws_iam_instance_profile.be_profile.name
  }

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [aws_security_group.be_sg.id]
  }

  user_data = filebase64("${path.module}/be-userdata.sh")

  tag_specifications {
    resource_type = "instance"
    tags          = { Name = "nit-dev-be-instance" }
  }

  tags = { Name = "nit-dev-be-lt" }
}