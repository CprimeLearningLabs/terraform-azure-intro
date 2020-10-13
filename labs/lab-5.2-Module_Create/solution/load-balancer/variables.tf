variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "port_mapping" {
  description = "map with keys: protocol, frontend_port, backend_port"
  type = object ({
    protocol      = string,
    frontend_port = number,
    backend_port  = number
  })
}

variable "health_probe" {
  description = "map with keys: protocol, port, request_path"
  type = object ({
    protocol     = string,
    port         = number,
    request_path = string
  })
}
