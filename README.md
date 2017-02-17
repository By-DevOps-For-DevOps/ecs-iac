# ngp-infrastructure

 This template  builds an [AWS CodePipeline](https://aws.amazon.com/codepipeline/)
 pipeline that implements a continuous delivery release
  process for AWS CloudFormation stacks. Submit a CloudFormation source artifact
  to an Amazon S3 location before building the pipeline. The pipeline uses the
  artifact to automatically create stacks and change sets.

## This will create
- VPC
- Two private Subnet with two NAT Gateways
- Two public Subnet with Internet Gateway
- ECS Cluster
- Security groups for ECS cluster and Loadbalancer

## Steps
1. Create your artifact S3 bucket
    - Enable Versioning on artifact bucket
    - Choose region same as your cloudfromation stack.
2. Clone the repo
3. Modify variables in `ecs-cluster-config.json` and `network-config.json`
4. Run `bash bin/configure.sh`
    - OR (do it mannualy)
        - Compress the files in `templates` directory in to zip (without any folder)
        - Upload the `.zip` file to S3 bucket.
        - Launch `infrastructure-pipeline.yaml` stack.
5. Confirm SNS subscription
    - Confirmation e-maill will be arrived in your e-mail box.
6. Go to CodePipeline Console, and approve Changesets.

## Delete Stack

Delete each stack by descending order because there are
dependencies between stacks.
