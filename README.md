This is the code for a [tutorial on Medium](https://medium.com/) I recently published.


# aws-fis-demo
Demo for AWS fault injection service (FIS)

**Prerequisites:**
You have an AWS account with a configured route53 zone.

As terraform does not yet support the fis service, the fis experiment
is created with a cloudformation template, installed by terraform.

**Usage:**
Adapt the values in locals.tf to your needs.
Create a terraform.tfvars file with your variable settings.

This project creates a vpc, an ec2 autoscaling group, an application loadbalancer
(with ssl certificate and s3 access logs) in front of the ec2 autoscaling group. The launch configuration for the 
ec2 instances deploys an ubuntu ami with an installed busybox httpd. The httpd replies
with the instance id of the ec2 instance. The access to
`https://var.fqdn/` is limited to the workstation ip you executed terraform.

The fis cloudformation template deploys a fis experiment that terminates 2 of the
ec2 instances of the autoscaling group. The fis experiment needs to be started manually
in the aws console.

This code has been tested with terraform 0.15.4

**Show your support**

Give a ⭐ if this project was helpful in any way!
