variable "region" {
  type = string
}

variable "vm_password" {
  description = "6-20 characters. At least 1 lower, 1 cap, 1 number, 1 special char."
  type = string
}

variable "db_storage" {
  type = number
  default = 5120

  validation {
    condition = var.db_storage >= 5120 && var.db_storage % 1024 == 0
    error_message = "Minimum db storage is 5120 and must be multiple of 1024."
  }
}
