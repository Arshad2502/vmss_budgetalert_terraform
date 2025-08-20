variable "prefix" {
  description = "The prefix which should be used for all resources in this example"
  default  = "ars"
}

variable "location" {
  description = "The Azure Region in which all resources in this example should be created."
  default = "Australia East"
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
