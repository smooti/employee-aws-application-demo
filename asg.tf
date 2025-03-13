# Create target group for application load balancer
resource "aws_lb_target_group" "app" {
  name        = "app-target-group"
  target_type = "instance"
  vpc_id      = module.vpc.vpc_id

  port     = 80
  protocol = "HTTP"

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 5
    timeout             = 30
    interval            = 40
  }
}

# Create security group for load balancer
resource "aws_security_group" "load-balancer" {
  vpc_id      = module.vpc.vpc_id
  name        = "load-balancer-sg"
  description = "HTTP Access"

  tags = {
    Name = "load-balancer-sg"
  }
}

# Allow http access in
resource "aws_vpc_security_group_ingress_rule" "lb-ingress" {
  security_group_id = aws_security_group.load-balancer.id
  from_port         = "80"
  to_port           = "80"
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
}

# Allow http access out
resource "aws_vpc_security_group_egress_rule" "lb-egress" {
  security_group_id = aws_security_group.load-balancer.id
  from_port         = "80"
  to_port           = "80"
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
}

# Create AWS application load balancer
resource "aws_lb" "app" {
  name               = "app-elb"
  load_balancer_type = "application"
  internal           = false
  subnets            = module.vpc.public_subnets_id

  security_groups = [aws_security_group.load-balancer.id]
}

# Add a listener to the load balancer
resource "aws_lb_listener" "app" {
  load_balancer_arn = aws_lb.app.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
}

# Create AWS launch template for autoscaling group
resource "aws_launch_template" "app" {
  name = "app-launch-template"

  image_id               = var.ec2_image_id # Amazon Linux
  instance_type          = var.ec2_instance_type
  update_default_version = true

  vpc_security_group_ids = [module.web.security_group_id]
  iam_instance_profile {
    arn = aws_iam_instance_profile.profile.arn
  }

  user_data = base64encode(templatefile("${path.root}/resources/user-data.tftpl", { photos-bucket = aws_s3_bucket.photos.id }))
}

# Create autoscaling group for application
resource "aws_autoscaling_group" "app" {
  depends_on          = [module.vpc]
  name                = "app-asg"
  vpc_zone_identifier = module.vpc.public_subnets_id
  desired_capacity    = 2
  min_size            = 2
  max_size            = 4

  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"
  }

  target_group_arns = [aws_lb_target_group.app.arn] # Attach auto scaling group to application load balancer Target Group
}
