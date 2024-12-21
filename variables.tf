variable "outscale_access_key" {
  description = "Your Outscale access key"
  type        = string
  sensitive   = true
}

variable "outscale_secret_key" {
  description = "Your Outscale secret key"
  type        = string
  sensitive   = true
}

variable "outscale_region" {
  description = "The region to deploy resources in"
  type        = string
}

variable "keypair_name" {
  description = "The name of your keypair"
  type        = string
}

variable "image_id" {
  description = "The ID of the machine image to use for the VM"
  type        = string
}

variable "vm_type" {
  description = "The type of VM to deploy"
  type        = string
}