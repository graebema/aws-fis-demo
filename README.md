# aws-fis-demo
Demo for AWS fault injection service (FIS)

Prerequisites:
You have an AWS account with a configured route53 zone.

Tested with terraform 0.15.4

As terraform does not yet support the fis service, the fis experiment
is created with a cloudformation template, installed by terraform.
