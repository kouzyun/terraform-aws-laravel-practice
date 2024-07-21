#!/bin/sh

# Set the remote destination
REMOTE_PATH="/var/www/menta/laravel/"

# get instance ids
INSTANCE_IDS=$(aws ec2 describe-instances --region ap-northeast-1 --filters "Name=tag:Type,Values=app" --query "Reservations[].Instances[].InstanceId" --output text)

#start ssm-session
session-manager-plugin

# Loop through each instance ID and execute rsync deploy
for INSTANCE_ID in $INSTANCE_IDS; do
    echo "rsync deploy $INSTANCE_ID"
    rsync --checksum -rv --exclude '.git' --include '.*' ~/project/laravel/ -e "ssh" $INSTANCE_ID:$REMOTE_PATH
done

# Loop through each instance ID and execute php migration
for INSTANCE_ID in $INSTANCE_IDS; do
    echo "php migration $INSTANCE_ID"
    ssh $INSTANCE_ID "cd /var/www/menta/laravel && composer install && php artisan key:generate && php artisan config:cache && php artisan migrate"
done