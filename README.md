# ngp-infrastructure-codepipeline

This template  builds an [AWS CodePipeline](https://aws.amazon.com/codepipeline/)
pipeline that implements a continuous delivery release process for AWS CloudFormation stacks.
Submit a CloudFormation source artifact to an Amazon S3 location before building the pipeline.
The pipeline uses the artifact to automatically create stacks and change sets.

## This will create

- VPC
- Two private Subnet with two NAT Gateways
- Two public Subnet with Internet Gateway
- ECS Cluster
- Security groups for ECS cluster and Application Load Balancer

## Steps to setup

1. Go the AWS region where we need to deploy the infrastructure
1. Create your artifact S3 bucket
    - Enable Versioning on artifact bucket
    - Choose region same as your cloudfromation stack. E.g. `ngp-v303-stage` for Development and Staging environment or `ngp-v303-prod` for Production environment.
1. Clone the repo:
   `git clone https://github.com/microservices-today/ngp-infrastructure-codepipeline.git`
   `cd ngp-infrastructure-codepipeline`
1. Modify variables in `templates/ecs-cluster-config.json` and `templates/network-config.json`
   Add your pem file name to `ecs-cluster-config.json` for accessing ECS instances. (e.g. `"KeyName" : "ngp-v303-stage"` if `ngp-v303-stage.pem` file)
1. Export AWS credentials (`AWS_DEFAULT_REGION` as deployment region)
    ```bash
    export AWS_ACCESS_KEY_ID="accesskey"
    export AWS_SECRET_ACCESS_KEY="secretkey"
    export AWS_DEFAULT_REGION="ap-southeast-1"
    ```
1. Run `bash bin/configure.sh`
   OR, Manually:
   - Compress the files in `templates` directory in to zip (without any folder)
   - Upload the `.zip` file to S3 bucket.
   - Launch `infrastructure-pipeline.yaml` stack.
1. Open the Link in Browser and for `Stack name` you may keep consistent (e.g. `ngp-v303-stage`)
1. TagName should be short, to avoid issue with AWS ALB naming limit w/ 32 characters. e.g. `v303`.
1. Confirm SNS subscription
    - Confirmation e-maill will be arrived in your e-mail box.
1. Go to CodePipeline Console, and approve Changesets.

## Steps to upgrade
1. Download `templates.zip` file from your S3 bucket where you store your CloudFormation source artifact (e.g. `ngp-v300-dev-stag`).
1. Unzip `templates` file. Copy `templates/ecs-cluster-config.json` and `templates/network-config.json` files into `templates` folder of this repo. It should overwrite existing default parameter files.
1. Make sure `ClusterSize` configuration in `ecs-cluster-config.json` is sufficient for rolling upgrade (it is important for Production environment).
1. Run `bash bin/configure.sh`. It will compress and upload files into the s3 bucket, which will trigger the infra pipeline.
1. From AWS console find your infra CodePipeline and manually approve in ApproveChangeSet.
1. Check Auto Scaling group, adjust manually if needed (TODO: currently doesn't work from CodePipeline).
