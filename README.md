# Azure Cloud Infrastructure (Terraform)

This repository contains the Terraform configuration for deploying our Azure Cloud Infrastructure, specifically focusing on the `dev` environment with reusable modules for Resource Groups and Storage Accounts.

## Project Structure
```
├── environments/
│   └── dev/                  # Development environment configurations
│       ├── main.tf           # Main file executing modules
│       ├── provider.tf       # Azure provider block
│       ├── terraform.tfvars  # Environment variables (rg name, storage name)
│       └── variables.tf      # Variable declarations
├── modules/
│   ├── resource_group/       # Reusable Resource Group Module
│   └── storage_account/      # Reusable Storage Account Module
└── .github/
    └── workflows/            # GitHub Actions CI/CD pipelines
        ├── terraform-plan.yml  # Runs on Pull Requests
        └── terraform-apply.yml # Runs on Main branch merges
```

## How the CI/CD Pipeline Works
This project uses **GitHub Actions** for Continuous Integration and Continuous Deployment (CI/CD). 

1. **Feature Branch (Pull Request)**:
   - When you create a new feature branch and open a Pull Request (PR) against `main`, the `terraform-plan.yml` workflow is triggered.
   - It only runs `terraform plan`. This ensures that your code is valid and shows you exactly what resources will be created, modified, or destroyed **without actually deploying anything**.
2. **Main Branch (Merge)**:
   - When the PR is merged into the `main` branch, the `terraform-apply.yml` workflow runs.
   - First, it runs a `terraform plan` to prepare the exact changes.
   - Then, it pauses and waits for **Manual Approval** before executing `terraform apply`. This prevents accidental deployments to the cloud.

---

## Setting Up GitHub CI/CD

To make the pipelines work, you need to configure your GitHub repository with Azure credentials, set up remote state, and configure Environment protections. Follow these steps carefully:

### Step 1: Create Terraform State Storage (Backend)
Terraform needs a remote location to store its `.tfstate` file so that GitHub Actions can track what resources have been deployed. 
Run these commands in Azure CLI to create a dedicated Resource Group and Storage Account for Terraform State:

```bash
# Variables
RESOURCE_GROUP_NAME="rg-terraform-state"
STORAGE_ACCOUNT_NAME="saterrformstatedemo2026" # Make sure this is unique
CONTAINER_NAME="tfstate"
LOCATION="centralindia"

# Create resource group
az group create --name $RESOURCE_GROUP_NAME --location $LOCATION

# Create storage account
az storage account create --resource-group $RESOURCE_GROUP_NAME --name $STORAGE_ACCOUNT_NAME --sku Standard_LRS --encryption-services blob

# Create blob container
az storage container create --name $CONTAINER_NAME --account-name $STORAGE_ACCOUNT_NAME
```
*(The backend block in `environments/dev/provider.tf` is already configured to use these names. If you change the names here, update them in `provider.tf` as well!)*

### Step 2: Push Code to GitHub
First, you need to push this code to a new GitHub repository:
```bash
git init
git add .
git commit -m "Initial commit with Terraform and GitHub Actions"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO_NAME.git
git push -u origin main
```

### Step 2: Add Azure Credentials to GitHub Secrets
To allow GitHub Actions to deploy resources in your Azure account, you need to create a Service Principal and store its details as **Repository Secrets**.

1. Run this command in your Azure CLI to create a Service Principal:
   ```bash
   az ad sp create-for-rbac --name "github-actions-sp" --role contributor --scopes /subscriptions/YOUR_SUBSCRIPTION_ID --sdk-auth
   ```
2. Note down the `clientId`, `clientSecret`, `subscriptionId`, and `tenantId` from the output.
3. Go to your GitHub Repository -> **Settings** -> **Secrets and variables** -> **Actions** -> **New repository secret**.
4. Add the following four secrets:
   - `ARM_CLIENT_ID`
   - `ARM_CLIENT_SECRET`
   - `ARM_SUBSCRIPTION_ID`
   - `ARM_TENANT_ID`

*(Documentation: [Use GitHub Actions to connect to Azure](https://learn.microsoft.com/en-us/azure/developer/github/connect-from-azure))*

### Step 3: Setup Manual Approvals (GitHub Environment)
To ensure the `main` branch doesn't deploy automatically without your permission, you must set up a GitHub Environment.

1. Go to your GitHub Repository -> **Settings** -> **Environments** -> **New environment**.
2. Name the environment exactly: **`dev`**
3. Under **Environment protection rules**, check the box for **Required reviewers**.
4. Add your GitHub username (or your team) as a reviewer and click **Save protection rules**.

*(Documentation: [Using environments for deployment](https://docs.github.com/en/actions/deployment/targeting-different-environments/using-environments-for-deployment))*

---

## Developing Locally
If you want to run Terraform locally to test your changes:

1. Navigate to the dev environment:
   ```bash
   cd environments/dev
   ```
2. Authenticate with Azure:
   ```bash
   az login
   ```
3. Initialize and Plan:
   ```bash
   terraform init
   terraform plan
   ```