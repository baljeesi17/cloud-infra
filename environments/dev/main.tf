module "resource_group" {
  source              = "../../modules/resource_group"
  resource_group_name = var.resource_group_name
  location            = var.location
  tags = {
    Environment = "Dev"
    Project     = "Terraform-Modules-Demo"
    ManagedBy   = "Terraform"
  }
}

module "storage_account" {
  source               = "../../modules/storage_account"
  storage_account_name = var.storage_account_name
  resource_group_name  = module.resource_group.name
  location             = var.location
  tags = {
    Environment = "Dev"
    Project     = "Terraform-Modules-Demo"
    ManagedBy   = "Terraform"
  }
  depends_on = [module.resource_group]
}
