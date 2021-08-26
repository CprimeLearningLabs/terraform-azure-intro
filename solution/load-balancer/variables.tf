variable "location" {
    description = "The location of the resource"
    type= string
}

variable "group_name" {
    description = "Resource group name"
    type = string
}

variable "tags" {
    type = map(string)
}
