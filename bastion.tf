
resource "aws_launch_configuration" "bastion_host" {
  name_prefix     = "bastion_asg-"
  image_id        = "ami-0c7478fd229861c57"
  instance_type   = "t2.micro"
  user_data       = file("user-data.sh")
  security_groups = [aws_security_group.bastion-sg.id]
  key_name        = "terraformKeypair"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "bastion_host" {
  name                 = "bastion_server"
  min_size             = 1
  max_size             = 3
  desired_capacity     = 3
  launch_configuration = aws_launch_configuration.bastion_host.name
  vpc_zone_identifier  = module.vpc.public_subnets
}
