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

## Structure
This project is structured as follows:
```
├── Makefile
├── templates
│   └── *.yaml
├── wordpress-dev.json
└── wordpress-prod.json
```

The `templates` folder contains the following:

```
├── alb.yaml
├── cloudfront.yaml
├── cloudwatch.yaml
├── ecs.yaml
├── efs.yaml
├── env.yaml
├── kms.yaml
├── network.yaml
├── rds.yaml
├── s3.yaml
├── secrets-manager.yaml
└── sns.yaml
```

Each file creates a piece of infrastructure.

In order to deploy this stack, `rain merge` is used to create one singular file.

## Prerequisites
In order to deploy this stack & work with it, the following tools are required:
- [rain](https://github.com/aws-cloudformation/rain)
- [jq](https://github.com/jqlang/jq)

## Makefile overrides
The `rain` binary in `Makefile` is called from `RAIN_CMD`, which defaults to `$HOME/go/bin/rain`.
Change this parameter if your path is different!

Example:

```bash
RAIN_CMD=/usr/local/bin/rain make deploy
```

Similarly, the following Makefile variables can be overridden:

- `STACK_NAME`: the name of the stack (default: `WordpressStack`)
- `RAIN_CMD`: path to `rain` (default: `${HOME}/go/bin/rain`)
- `PARAMS_FILE`: path to the development parameters (default: `wordpress-dev.json`)
- `PARAMS_FILE_PROD`: path to the production parameters (default: `wordpress-prod.json`)

## Deploying the stack
Deploying the CloudFormation stack is real easy.

The provided `Makefile` provides the following commands:
- `make lint`: lint the merged CloudFormation template
- `make deploy`: deploy the CloudFormation stack using rain (development values)
- `make deploy-prod`: deploy the CloudFormation stack using rain (production values)
- `make deploy-aws`: deploy the CloudFormation stack using the AWS CLI with (development values)
- `make deploy-aws-prod`: deploy the CloudFormation stack using the AWS CLI (production values)
- `make update-aws`: update the CloudFormation stack using the AWS CLI (development values)
- `make update-aws-prod`: update the CloudFormation stack using the AWS CLI (production values)
- `make delete`: delete the deployed CloudFormation stack using the AWS CLI
- `make clean`: remove the merged CloudFormation template

Running `make deploy` is an easy, hassle-free way to get started with this stack.

### Outputs
The following outputs are produced:
- `CFDomainName`: the CloudFront distribution's publicly-accessible DNS Name. This is the Wordpress deployment's URL.
