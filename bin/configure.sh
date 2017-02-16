#!/usr/bin/env bash
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color


echo -e "\nPlease specify the preferred version of the application (Leave empty for the master version).
You can find the latest release version here.${GREEN}https://github.com/microservices-today/ngp-infrastructure/releases.${NC}"
read VERSION
if [ "$VERSION" == "DEV" -o "$VERSION" == "dev" ]; then #skip for development
    echo -- Development mode --
else
    git checkout .
    if [[ -z "$VERSION" ]]; then
         git checkout master
       else
         git checkout tags/$VERSION
    fi
fi
echo -e "\nSpecify the S3 bucket name for storing the templates, the bucket should be in same region of CodePipeline"
read S3_BUCKET_NAME

echo -e "Enter the AWS REGION to deploy the Cloudformation Stack [default: ap-northeast-1]"
read AWS_REGION
if [[ -z "$AWS_REGION" ]]; then
    AWS_REGION=ap-northeast-1
fi

cd templates
zip -r templates.zip ./*
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
