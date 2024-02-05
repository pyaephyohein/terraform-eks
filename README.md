# Create EKS cluster with terraform cli
## Config your aws profile
```
aws configure --profile {your-aws-profile-name}
```
## Export your AWS CLI Profile
```bash
export AWS_PROFILE={your-aws-profile-name}
```
## Edit env.json
```json
{
    "name" :"mgou-eks",
    "environment" : "testing",
    "region" : "ap-southeast-1",
    "availablity_zones" : ["ap-southeast-1a", "ap-southeast-1b", "ap-southeast-1c"],
    "vpc_cidr" : "10.0.0.0/16",
    "private_subnets" : ["10.0.1.0/24","10.0.2.0/24"],
    "public_subnets" : ["10.0.101.0/24","10.0.102.0/24"],
    "enable_nat_gw" : true,
    "enable_vpn_gw" : false,
    "k8s_version" : "1.28",
    "node_group_min_size" : "1",
    "node_group_max_size" : "1",
    "node_group_desire_size" : "1",
    "node_group_capacity_type" : "ON_DEMAND",
    "node_instance_type" :"t2.medium",
    "node_disk_size": "80",
    "iam_admin_group_name" : "admin",
    "addon_tags" : {
        "tfmaintainer" : "mgou.dev",
        "github_repo" : "github.com/pyaephyohein/terraform-eks"
    }
    
}
```

## Create Backend Config
```bash
cd backend
terraform init
terraform apply --var-file=../env.json
```
## Create EKS Cluster

```bash
cd eks
terraform init --backend=../backend/backend.json
terraform apply --var-file=../env.json
```

# Create EKS cluster with gitlab-ci

## Add CICD ENV on repo setting > CI/CD > Variables
```bash
AWS_ACCESS_KEY_ID={your-access-key}
AWS_SECRET_ACCESS_KEY={your-secret-key}
AWS_REGION={aws-region}
BUCKET_NAME={state-backet-name} #Format {name}-{environment}-{state} from env.json
```
## Run on GITLAB-CI Pipeline


# Create EKS cluster with bashscript

```bash
chmod +x ./utility.sh
./utility.sh --help

./utility.sh --install backend --stage plan
./utility.sh --install backend --stage apply

./utility.sh --install eks --stage plan
./utility.sh --install eks --stage apply
```


# Access EKS Cluster 

```bash
aws eks update-kubeconfig --region {your-region} --name {cluster_name}

## Copy context
kubectl config use-context {context_name}
```
