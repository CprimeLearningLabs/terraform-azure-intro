variable "location" {
  description = "Region in which to create the backend storage accounts."
  type = string
}

variable "sequence" {
  description = "Two-digit sequence number for this subscription to append to storage account name."
  type = string
}
