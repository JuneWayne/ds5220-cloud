# Run an EC2 instance with code

## Setup

Install the AWS CLI:

- Follow [these instructions](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html#getting-started-install-instructions) for your platform.

Install your security keys:

- Create your access keys using the AWS Console
- Run `aws configure` and follow the prompts. Specify the `us-east-1` region and use the `json` output format.

## Create a Reusable Security Group

Create a group with the following ingress rules:
- SSH (TCP port 22) - available from `199.111.0.0/16`
- HTTP (TCP port 80) - available from `0.0.0.0/0`
- Custom (TCP port 8080) - available from `0.0.0.0/0`

Or create this group using the AWS CLI:

```
# requires two steps: group creation and adding ingress rules:
# Default VPC is used unless specified using --vpc-id

aws ec2 create-security-group \
  --group-name my-sg \
  --description "My security group"
```
This returns the Group ID:
```
{
    "GroupId": "sg-071a0ac3f56923d09"
}
```
Then add ingress rules. Customize this and repeat as necessary:
```
aws ec2 authorize-security-group-ingress \
  --group-id sg-071a0ac3f56923d09 \
  --protocol tcp \
  --port 22 \
  --cidr 199.111.0.0/16
```

## Create Instances

A normal Ubuntu 24.04LTS instance can be created using the CLI. Be sure to replace the name of your `KEY` and the ID of your security group you created above.

```
# ubuntu 24.04LTS

aws ec2 run-instances \
  --image-id ami-0b6c6ebed2801a5cb \
  --count 1 \
  --instance-type t3.micro \
  --key-name ds5220 \
  --security-group-ids sg-066412c1406b41de3 \
  --user-data file://bootstrap-1.sh
```

```
# simple pre-baked container image

aws ec2 run-instances \
  --image-id ami-0b6c6ebed2801a5cb \
  --count 1 \
  --instance-type t3.large \
  --key-name ds5220 \
  --security-group-ids sg-066412c1406b41de3 \
  --user-data file://bootstrap-2.sh
  ```

```
# docker compose

aws ec2 run-instances \
  --image-id ami-0b6c6ebed2801a5cb \
  --count 1 \
  --instance-type t3.large \
  --key-name ds5220 \
  --security-group-ids sg-066412c1406b41de3 \
  --user-data file://bootstrap-3.sh
  ```

```
# docker via cloud-config

aws ec2 run-instances \
  --image-id ami-0b6c6ebed2801a5cb \
  --count 1 \
  --instance-type t3.large \
  --key-name ds5220 \
  --security-group-ids sg-066412c1406b41de3 \
  --user-data file://bootstrap-4.txt
  ```

You can also use the CLI to find running instances and their IP addresses:

```
aws ec2 describe-instances \
  --filters "Name=instance-state-name,Values=running" \
  --query 'Reservations[0].Instances[0].[InstanceId,PublicIpAddress]' \
  --output text
```

Finally, you can stop or terminate an instance by ID:

```
aws ec2 stop-instances --instance-ids i-0d809bad47d42f16d
aws ec2 termiante-instances --instance-ids i-0d809bad47d42f16d
```
