# Terraform AWS Infrastructure

This repository contains Terraform code to provision and manage AWS networking infrastructure, including a VPC, subnets, and related components.

## Project Structure
```
TF-AWS-INFRA-MAIN/
│── .github/          # GitHub-related workflows (if any)
│── modules/          # Reusable Terraform modules
│── .gitignore        # Git ignore file for excluding files from version control
│── LICENSE           # License file for the project
│── main.tf           # Main Terraform configuration file
│── outputs.tf        # Defines Terraform output variables
│── provider.tf       # Specifies cloud provider configuration (e.g., AWS)
│── README.md         # Documentation for the project
│── variables.tf      # Defines input variables for the Terraform configuration
```

## AWS Services Used
- **VPC (Virtual Private Cloud):** Creates an isolated network environment.
- **Subnets:** Defines public and private subnets within the VPC.
- **Internet Gateway:** Enables internet access for public subnets.
- **Route Tables:** Manages traffic routing within the VPC.

## Prerequisites
- Install **Terraform**: [Download Terraform](https://developer.hashicorp.com/terraform/downloads)
- Configure **AWS CLI** with appropriate credentials:
  ```sh
  aws configure --profile dev
  ```
- Ensure you have an **AWS account** with necessary permissions.

## Usage
### 1. Initialize Terraform
Run the following command to initialize Terraform and install required providers:
```sh
terraform init
```

### 2. Plan the Deployment
View what changes Terraform will apply:
```sh
terraform plan
```

### 3. Apply Changes
Deploy the infrastructure:
```sh
terraform apply
```
Confirm with **yes** when prompted.

### 4. Destroy Infrastructure
To delete all resources created by Terraform:
```sh
terraform destroy
```
Confirm with **yes** when prompted.

## Outputs
After applying, Terraform will output essential resource details, such as:
- **VPC ID**
- **Public Subnet IDs**
- **Private Subnet IDs**

## Best Practices
- Use **Terraform modules** for reusable components.
- Store sensitive data securely (avoid hardcoding credentials).
- Version-control your Terraform state when working in teams.

## License
This project is licensed under the [MIT License](LICENSE).

