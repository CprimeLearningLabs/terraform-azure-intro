variable "region" {
    description = "The location of the resource"
    type= string
    default= "westus2"
}

variable "vm_password" {
    description= "Password of the VM"
    type= string
    sensitive= true
}

variable "db_storage_amount" {
    description= "The DB storage amount"
    type= number
    default= 5120
}

variable "tags" {
    type = map(string)
    default = {}
}

variable "node_count" {
    type = number
    default = null
}

variable "load_level" {
    type = string
    default = ""
}
