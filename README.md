# Wordpress deployment on AWS

This project creates a secure, resilient, scalable, replicable, distributed Wordpress deployment.

The following technologies are used:
- AWS CloudFormation (stack deployment)
- AWS CloudFront
- AWS CloudWatch
- AWS ECS
- AWS EFS
- AWS ELB
- AWS IAM
- AWS KMS
- AWS RDS
- AWS S3
- AWS SNS
- AWS Secrets Manager
- AWS VPC

![Infra](infra.png)

## Deploying the stack
Deploying the CloudFormation stack is real easy.
Just run `make deploy`, and the `WordpressStack` dev stack will be deployed.

That's it! The stack should now be successfully deployed.

In the **Outputs** section of the newly created CloudFormation stack, you should see the following key-value pair:
- `CFDomainName`: the CloudFront distribution's publicly-accessible DNS Name. This is the Wordpress deployment's URL.
