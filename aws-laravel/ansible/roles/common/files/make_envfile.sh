#!/bin/sh

# laravel path setting
LARAVEL_PATH=/var/www/menta/laravel

# get ISMD token
TOKEN=$(curl -X PUT -H "X-aws-ec2-metadata-token-ttl-seconds: 600" "http://169.254.169.254/latest/api/token")

# ssm parameter-store settings
INSTANCE_ID=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/instance-id)
ZONE=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/placement/availability-zone)
REGION=$(echo ${ZONE/%?/})
APP_NAME=$(aws --region ${REGION} ec2 describe-instances --instance-ids ${INSTANCE_ID} --query "Reservations[0].Instances[0].Tags[?Key=='Name'].Value" --output text)
APP_ENV=$(aws --region ${REGION} ec2 describe-instances --instance-ids ${INSTANCE_ID} --query "Reservations[0].Instances[0].Tags[?Key=='Env'].Value" --output text)
FILENAME="${LARAVEL_PATH}/.env"

# append ssm parameters to .env
SSM_PARAMS=$(aws --region ${REGION} ssm get-parameters-by-path --path "/RDS/MYSQL/"  --with-decryption)

for params in $(echo $SSM_PARAMS | jq -r '.Parameters[] | .Name + "=" + .Value'); do
    echo ${params##*/}
done >> ${FILENAME}