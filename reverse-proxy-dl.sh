#!/bin/bash
# Script to automate making a DEV NGINX Instance
# October 2018
# John Elliott (john.elliott@aplaceformom.com)
# v0.2

# For now, the RP lives in the ROOT AWS Environment
export AWS_PROFILE=default

function instanceId {
# Get first InstanceId and PrivateIpAddress
printf "I'm trying to get the first InstanceId of the Reverse Proxy\nStandby...\n"
instance_id=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=USW2NGINX" | jq -r "[.Reservations[].Instances[].InstanceId][0]")
instance_ip=$(aws ec2 describe-instances --instance-ids "$instance_id" | jq -r "[.Reservations[].Instances[].PrivateIpAddress][0]")
if [[ $instance_id = "null" ]] || [[ $instance_ip = "null" ]]
then printf "Looks like I can't find that InstanceId!\n"
exit
fi
}

function detach {
# Detach the instance, making sure it brings up a new one
aws autoscaling detach-instances --instance-ids $instance_id --auto-scaling-group-name nginx-reverse-proxy --no-should-decrement-desired-capacity
}

function tags {
# Delete ALL tags and create new ones
aws ec2 delete-tags --resources $instance_id

aws ec2 create-tags --resources $instance_id --tags Key=Name,Value="www"
aws ec2 create-tags --resources $instance_id --tags Key=App,Value="nginx"
aws ec2 create-tags --resources $instance_id --tags Key=Env,Value="dev"
aws ec2 create-tags --resources $instance_id --tags Key=Owner,Value="ops"
aws ec2 create-tags --resources $instance_id --tags Key=Schedule,Value="M-F"
aws ec2 create-tags --resources $instance_id --tags Key=Start,Value="09:00:US/Pacific"
aws ec2 create-tags --resources $instance_id --tags Key=Stop,Value="17:00:US/Pacific"
}

function dumpvars {
# print the Instance ID
printf "Instance ID $instance_id\n"
printf "Instance IP $instance_ip\n"
}

instanceId

detach

tags

dumpvars
