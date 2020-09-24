import boto3
import os

# Boto Connection
ec2 = boto3.resource('ec2', os.getenv("AWS_REGION"))

def lambda_handler(event, context):
  # Filters
  filters = [{
      'Name': 'tag:AutoStop',
      'Values': ['true']
    },
    {
      'Name': 'instance-state-name',
      'Values': ['running']
    }
  ]

  # Filter running instances that should stop
  instances = ec2.instances.filter(Filters=filters)

  # Retrieve instance IDs
  instance_ids = [instance.id for instance in instances]

  # stopping instances
  stopping_instances = ec2.instances.filter(Filters=[{'Name': 'instance-id', 'Values': instance_ids}]).stop()