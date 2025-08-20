variable "prefix" {
  description = "The prefix which should be used for all resources"
  default  = "ars"
}

variable "location" {
  description = "The Azure Region in which all resources should be created."
  default = "West US 2"
}

variable "admin_password" {
  description = "Admin password for VMSS"
  type        = string
  sensitive   = true
}

variable "admin_username" {
  description = "Admin username for VMSS"
  type        = string
  sensitive   = true
} 
