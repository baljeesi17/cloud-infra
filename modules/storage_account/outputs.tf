output "id" {
  description = "The ID of the Storage Account"
  value       = azurerm_storage_account.sa.id
}

output "name" {
  description = "The Name of the Storage Account"
  value       = azurerm_storage_account.sa.name
}

output "primary_blob_endpoint" {
  description = "The primary endpoint for blob storage"
  value       = azurerm_storage_account.sa.primary_blob_endpoint
}
