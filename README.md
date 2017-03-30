# ngp-infrastructure

This template  builds an [AWS CodePipeline](https://aws.amazon.com/codepipeline/)
pipeline that implements a continuous delivery release process for AWS CloudFormation stacks.
Submit a CloudFormation source artifact to an Amazon S3 location before building the pipeline.
The pipeline uses the artifact to automatically create stacks and change sets.

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
   `git clone https://github.com/microservices-today/ngp-infrastructure-codepipeline.git`  
   `cd ngp-infrastructure-codepipeline`
3. Modify variables in `templates/ecs-cluster-config.json` and `templates/network-config.json`
   Add your pem file name to `ecs-cluster-config.json` for accessing ECS instances. (e.g. `"KeyName" : "ecs"` if ecs.pem file)
4. Export AWS credentials   
```
export AWS_ACCESS_KEY_ID="accesskey"   
export AWS_SECRET_ACCESS_KEY="secretkey"    
export AWS_DEFAULT_REGION="ap-northeast-1"   
```
5. Run `bash bin/configure.sh`   
   OR, Manually  
   - Compress the files in `templates` directory in to zip (without any folder)
   - Upload the `.zip` file to S3 bucket.
   - Launch `infrastructure-pipeline.yaml` stack.
6. Confirm SNS subscription
    - Confirmation e-maill will be arrived in your e-mail box.
7. Go to CodePipeline Console, and approve Changesets.

## Delete Stack

Delete each stack by descending order because there are
dependencies between stacks.
