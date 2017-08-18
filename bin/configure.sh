#!/usr/bin/env bash
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color


echo -e "\nSpecify the ${GREEN}S3 bucket name${NC} for storing the templates, the bucket should be in same region of CodePipeline"
read S3_BUCKET_NAME

echo -e "Enter the ${GREEN}AWS REGION${NC} to deploy the Cloudformation Stack [default: ${BLUE}ap-southeast-1${NC}]"
read AWS_REGION
if [[ -z "$AWS_REGION" ]]; then
    AWS_REGION=ap-southeast-1
fi

cd templates
zip -r templates.zip ./* -x *~
aws s3 cp templates.zip s3://${S3_BUCKET_NAME}/
rm templates.zip
cp ../infrastructure-pipeline.yaml .
sed -i -e "s@S3_BUCKET_NAME@${S3_BUCKET_NAME}@g" infrastructure-pipeline.yaml
aws s3 cp infrastructure-pipeline.yaml s3://${S3_BUCKET_NAME}/
rm infrastructure-pipeline.yaml

URL="https://console.aws.amazon.com/cloudformation/home?region=${AWS_REGION}#/stacks/new?templateURL=https://s3.amazonaws.com/${S3_BUCKET_NAME}/infrastructure-pipeline.yaml"
echo -e "Open the Link in Browser --- ${GREEN}${URL}${NC}"
if which xdg-open > /dev/null
then
  xdg-open $URL
elif which gnome-open > /dev/null
then
  gnome-open $URL
fi
