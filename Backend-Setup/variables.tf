variable "subscription-ids" {
  description = "Map of subscriptions ids, where the key is the two-digit student sequence number for the subscription."
  type = map(string)
}

variable "location" {
  description =  "Region in which to create the backend storage accounts."
  type = string
}
