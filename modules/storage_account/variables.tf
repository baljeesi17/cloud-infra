variable "storage_account_name" {
  description = "The name of the storage account"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the storage account"
  type        = string
}

variable "location" {
  description = "The Azure Region where the storage account should exist"
  type        = string
}

variable "account_tier" {
  description = "Defines the Tier to use for this storage account (e.g., Standard, Premium)"
  type        = string
  default     = "Standard"
}

variable "account_replication_type" {
  description = "Defines the type of replication to use for this storage account (e.g., LRS, GRS, RAGRS, ZRS)"
  type        = string
  default     = "LRS"
}

variable "tags" {
  description = "Tags to be applied to resources"
  type        = map(string)
  default     = {}
}
