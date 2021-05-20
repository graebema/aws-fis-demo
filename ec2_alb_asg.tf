# domain validated certificate for alb
module "acm" {
  source = "./modules/acm"
  zone   = var.zone # foo.com
  fqdn   = var.fqdn # service.foo.com
  tags   = local.tags
}
output "acm_cert" { value = module.acm.cert_arn }

# dns alias a-record for alb
module "dns_alias_alb" {
  source         = "./modules/dns_alias"
  zone           = var.zone # foo.com
  fqdn           = var.fqdn # service.foo.com
  target         = module.alb.alb_dns_name
  target_zone_id = module.alb.alb_zone_id
}

## alb tg
resource "aws_lb_target_group" "alb_tg" {
  name        = "alb-fis"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = module.vpc.vpc_id
  target_type = "instance"
  tags        = local.tags
  health_check {
    enabled = true
    path    = "/"
    timeout = 10
  }
}

module "alb" {
  source         = "./modules/alb_ssl"
  alb_name       = "alb-fis"
  alb_subnet_ids = module.vpc.public_subnet_ids
  alb_securitygroup_ids = [
    aws_security_group.allow-ping.id,
    aws_security_group.allow-https.id
  ]
  alb_cert_arn        = module.acm.cert_arn
  alb_targetgroup_arn = aws_lb_target_group.alb_tg.arn
  tags                = local.tags
}



# image for ec2 asg

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

### create asg with launch configuration
resource "aws_launch_configuration" "as_conf" {
  name                 = "web_config"
  image_id             = data.aws_ami.ubuntu.id
  instance_type        = "t2.micro"
  iam_instance_profile = aws_iam_instance_profile.ec2-role-instanceprofile.id
  security_groups = [
    aws_security_group.allow-ping.id,
    aws_security_group.allow-http-alb.id
  ]
  user_data = data.template_file.shell-script.rendered
}

# busybox httpd server
data "template_file" "shell-script" {
  template = file("httpd.sh")
}

resource "aws_autoscaling_group" "web-asg" {
  name                      = "web-asg"
  depends_on                = [aws_launch_configuration.as_conf]
  vpc_zone_identifier       = [module.vpc.private_subnet_ids.0, module.vpc.private_subnet_ids.1]
  max_size                  = 3
  min_size                  = 2
  health_check_grace_period = 60
  health_check_type         = "EC2"
  desired_capacity          = 3
  force_delete              = true
  launch_configuration      = aws_launch_configuration.as_conf.id
  target_group_arns         = [aws_lb_target_group.alb_tg.arn]
  tag {
    key                 = "Name"
    value               = var.asg_name
    propagate_at_launch = true
  }
}
