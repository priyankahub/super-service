**Part 2: Infrastructure Setup**

Steps to set up the infrastructure for the application using AWS-
1. Kubernetes Cluster Setup on AWS EKS
2. Networking Configuration
3. Ingress Controller Setup
4. Monitoring and Notifications
5. CI/CD Pipeline Setup
   
**----------------------------------[Step 1: K8s Setup on AWS]-----------------------------------------------**

A. Install AWS CLI command-
>> aws configure

B. Create an EKS Cluster (named super-service-cluster with 3 t3.medium nodes) using eksctl-
>> eksctl create cluster --name super-service-cluster --version 1.21 --region us-west-2 --nodegroup-name standard-workers --node-type t3.medium --nodes 3 --nodes-min 1 --nodes-max 4 --managed

C. Install and connect kubectl to the Cluster-
>> curl -o kubectl https://amazon-eks.s3.us-west-2.amazonaws.com/1.21.0/2021-09-09/bin/linux/amd64/kubectl
>> 
>> chmod +x ./kubectl
>> 
>> mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$PATH:$HOME/bin

D. Update kubeconfig:
>> aws eks --region us-west-2 update-kubeconfig --name super-service-cluster

**-----------------------------------[Step 2: Networking Configuration]-----------------------------------**

A. Create a VPC:
Use AWS Management Console or CloudFormation to create a VPC with public and private subnets.

B. VPC Peering:
Create a peering connection between the VPC and the internal-assets VPC.
>> aws ec2 create-vpc-peering-connection --vpc-id vpc-12345678 --peer-vpc-id vpc-87654321 --peer-region us-west-2

Accept the peering connection in the target VPC.
>> aws ec2 accept-vpc-peering-connection --vpc-peering-connection-id pcx-12345678

Update route tables to allow traffic between the VPCs.

**-----------------------------------[Step 3: Ingress Controller Setup]-----------------------------------**

A. Deploy NGINX Ingress Controller

Add the NGINX Ingress Controller Helm repository:
>> helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
>> helm repo update

Install the NGINX Ingress Controller using Helm:
>> helm install ingress-nginx ingress-nginx/ingress-nginx --namespace ingress-nginx --create-namespace

B. Create an Ingress Resource (refer super-service-ingress) and apply it:
>> kubectl apply -f super-service-ingress.yaml

**-----------------------------------[Step 4: Monitoring and Notifications]-----------------------------------**

A. Set up CloudWatch Logging:

Create a CloudWatch Log Group:
>> aws logs create-log-group --log-group-name /eks/super-service

Update EKS Cluster to use the Log Group:
>> eksctl utils update-cluster-logging --cluster super-service-cluster --enable-types all --region us-west-2

B. Create CloudWatch Alarms and SNS Notifications:

Create an SNS Topic:
>> aws sns create-topic --name SuperServiceAlerts

Subscribe to the SNS Topic:
>> aws sns subscribe --topic-arn arn:aws:sns:us-west-2:123456789012:SuperServiceAlerts --protocol email --notification-endpoint the-email@example.com

Create a CloudWatch Alarm:
>> aws cloudwatch put-metric-alarm --alarm-name HighCPUUtilization --metric-name CPUUtilization --namespace AWS/EC2 --statistic Average --period 300 --threshold 80 --comparison-operator GreaterThanOrEqualToThreshold --dimensions Name=InstanceId,Value=i-1234567890abcdef0 --evaluation-periods 2 --alarm-actions arn:aws:sns:us-west-2:123456789012:SuperServiceAlerts

**-----------------------------------[Step 5: CI/CD Pipeline Setup]-----------------------------------**

A. Jenkins Setup:

A. Install Jenkins & Create a Jenkins Pipeline (refer Jenkinsfile).

B. Configure Jenkins - 
Set up credentials for Docker Hub and Kubernetes.
Create a new pipeline job and point it to the Jenkinsfile.

**-----------------------------------[SUMMARY]-----------------------------------**

By following these steps, we will set up a infrastructure on AWS for the application. 
This setup ensures that the application is deployed in a secure, scalable, and automated environment with proper monitoring and notification systems in place.
