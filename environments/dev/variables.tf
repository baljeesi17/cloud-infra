variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "location" {
  description = "The Azure Region where the resource group and storage account should exist"
  type        = string
}

variable "storage_account_name" {
  description = "The name of the storage account"
  type        = string
}
