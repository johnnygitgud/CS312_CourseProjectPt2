variable "my_ip_cidr" {
  description = "Your public IP address in CIDR format for SSH access"
  type        = string
}

variable "key_name" {
  description = "Existing Minecraft Key"
  type        = string
}