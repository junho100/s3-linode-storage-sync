#!/bin/bash
# <UDF name="SRC_REGION" label="Source Bucket Region" oneOf="ap-south-2,ap-south-1,eu-south-1,eu-south-2,me-central-1,il-central-1,ca-central-1,eu-central-1,eu-central-2,us-west-1,us-west-2,af-south-1,eu-north-1,eu-west-3,eu-west-2,eu-west-1,ap-northeast-3,ap-northeast-2,me-south-1,ap-northeast-1,sa-east-1,ap-east-1,ca-west-1,ap-southeast-1,ap-southeast-2,ap-southeast-3,ap-southeast-4,us-east-1,us-east-2"/>
# <UDF name="SRC_BUCKET" label="Source Bucket Name" default="" />
# <UDF name="SRC_ACCESSKEY" label="Source Bucket Access Key" default="" />
# <UDF name="SRC_SECRETKEY_PASSWORD" label="Source Bucket Secret Key" default="" />
# <UDF name="DEST_REGION" label="Destination Bucket Region" default="jp-osa-1" oneOf="nl-ams-1,us-southeast-1,in-maa-1,us-ord-1,eu-central-1,id-cgk-1,us-lax-1,es-mad-1,us-mia-1,it-mil-1,us-east-1,jp-osa-1,fr-par-1,br-gru-1,us-sea-1,ap-south-1,se-sto-1,us-iad-1"/>
# <UDF name="DEST_BUCKET" label="Destination Bucket Name" default="" />
# <UDF name="DEST_ACCESSKEY" label="Destination Bucket Access Key" default="" />
# <UDF name="DEST_SECRETKEY_PASSWORD" label="Destination Bucket Secret Key" default="" />
# <UDF name="RCLONE_FREQUENCY_MINUTE" label="Minutes to synchronize" default=5 />
sudo apt-get update
sudo apt-get install rclone -y
echo "Rclone installation completed."
# Rclone configuration file
CONFIG_FILE="$HOME/.config/rclone/rclone.conf"
# Rclone Directory creation
# This should be manually configured as it may be under /root directory
CONFIG_DIR=$(dirname "$CONFIG_FILE")
mkdir -p "$CONFIG_DIR"
# Rclone configuration context
CONFIG_CONTENT="[src_region] 
type = s3
provider = AWS
access_key_id = $SRC_ACCESSKEY
secret_access_key = $SRC_SECRETKEY_PASSWORD
endpoint = https://s3.$SRC_REGION.amazonaws.com
acl = private
region = $SRC_REGION
[dest_region]
type = s3
provider = Ceph
access_key_id = $DEST_ACCESSKEY
secret_access_key = $DEST_SECRETKEY_PASSWORD
endpoint = https://$DEST_REGION.linodeobjects.com
acl = private"
# copy the config context to the config file
echo "$CONFIG_CONTENT" | sed 's/\[/\n\[/g' > "$CONFIG_FILE"
# verify if config file is created
if [ -f "$CONFIG_FILE" ]; then
    echo "Rclone config file is created at $CONFIG_FILE"
else
    echo "Failed to create Rclone config file."
    exit 1
fi
#Run the first rclone sync command
RCLONE_SYNC_COMMAND="rclone sync -vv src_region:$SRC_BUCKET dest_region:$DEST_BUCKET --log-file=$CONFIG_DIR/rclone.log"
$RCLONE_SYNC_COMMAND
#Optional and be cautious of extensive stress to storages
#Setup crontab to run periodic Rclone sync commands
echo "*/$RCLONE_FREQUENCY_MINUTE * * * * $RCLONE_SYNC_COMMAND" >> /tmp/crontab.tmp
crontab /tmp/crontab.tmp
rm /tmp/crontab.tmp