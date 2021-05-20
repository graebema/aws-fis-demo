resource "aws_cloudformation_stack" "fis-experiment-ec2" {
  name          = "fis-experiment-ec2"
  capabilities  = ["CAPABILITY_IAM"]
  template_body = file("${path.module}/fis_experiment_ec2.yml")
  parameters = {
    EC2NameTag = var.asg_name
  }
  tags = local.tags
}
