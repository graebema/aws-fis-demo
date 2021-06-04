This is the code for a [tutorial on Medium](https://medium.com/) I recently published.


# aws-fis-demo
A demo for the AWS Fault Injection Service (FIS).

**Prerequisites:**
You have an AWS account with a configured Route53 zone.

As Terraform does not yet support the FIS service, the FIS experiment
is created with a CloudFormation template, installed by Terraform.

**Usage:**
Adapt the values in locals.tf to your needs.
Create a terraform.tfvars file with your variable settings.

This project creates a VPC, an EC2 autoscaling group, and an application loadbalancer
(with ssl certificate and S3 access logs) in front of the EC2 autoscaling group. The launch configuration for the 
EC2 instances deploys an Ubuntu ami with an installed busybox httpd. The httpd replies
with the instance ID of the specific EC2. The access to
`https://var.fqdn/` is limited to the workstation ip from which you executed Terraform.

The FIS CloudFormation template deploys a FIS experiment that terminates 2 of the
EC2 instances of the autoscaling group. The FIS experiment needs to be started manually
in the AWS console.

This code has been tested with Terraform v0.15.4.

**Show your support**

Give a ⭐ if this project was helpful in any way!
