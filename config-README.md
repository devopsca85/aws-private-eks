## Overview
This Terraform configuration sets up an AWS Virtual Private Cloud (VPC) with public and private subnets. It also deploys a bastion host within a public subnet for secure access.
## Prerequisites
Before you start, ensure you have:
1. AWS CLI configured with appropriate credentials.
2. Terraform installed on your local machine.
## Usage
1. Clone this repository to your local machine.
2. Navigate to the project directory.
3. Create a `terraform.tfvars` file to set your variables. 
4. Initialize Terraform:
       terraform init
   5. Preview the changes:
    terraform plan
6. Apply the changes:
    ```
    terraform apply
    ```
7. Once the provisioning is complete, access the bastion host via SSH:
    ```shell
    ssh -i /path/to/your/key.pem ec2-user@BASTION_PUBLIC_IP
    ```
8. Once provisioning is complete, you can access your EKS cluster using `kubectl`. Configure `kubectl` with the generated kubeconfig file:

    ```shell
    aws eks --region <your-region> update-kubeconfig --name <your-cluster-name>
    ```

9. Verify your EKS cluster:
    ```shell
    kubectl get nodes

## Cleanup
To remove the created resources, use:
```
terraform destroy
