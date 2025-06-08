import boto3

ec2 = boto3.client('ec2')

def lambda_handler(event, context):
    filters = [
        {'Name': 'tag:Env', 'Values': ['dev']},
        {'Name': 'instance-state-name', 'Values': ['running']}
    ]
    instances = ec2.describe_instances(Filters=filters)
    
    instance_ids = []
    for reservation in instances['Reservations']:
        for instance in reservation['Instances']:
            instance_ids.append(instance['InstanceId'])
    
    if instance_ids:
        ec2.stop_instances(InstanceIds=instance_ids)
        print(f"Stopped instances: {instance_ids}")
    else:
        print("No running dev instances to stop.")
