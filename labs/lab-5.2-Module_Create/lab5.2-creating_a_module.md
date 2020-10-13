# Creating a Module

Lab Objective
- Convert the load balancer configuration in your code to a module
- Use the new module in your configuration

## Preparation

If you did not complete lab 5.1, you can simply copy the code from that lab (and do terraform apply) as the starting point for this lab.

## Lab

### Modify code to implement the module

In this lab we will convert the load balancer configuration to be a module implementation.  We will implement the module as a nested module, though in actual practice this module should probably be a module on its own.

Create a subdirectory called “load-balancer”.
```
mkdir load-balacer
```

Move the “lb.tf” file to the “load-balancer” directory and rename the file “main.tf”.  (Recall that each module should have a main.tf file as the principal configuration entry point.)

Within the “load-balancer” directory, create a file called “variables.tf”.

Go through the **load balancer main.tf** file and look for what arguments will need values passed into the module.  (The load balancer module cannot access the parent resources directly.)  These are candidates for the input variables for the load balancer module.

In the load balancer variables.tf file, add variables for the following:
  * location
  * resource group name
  * tags

If you are ambitious, try adding variables for the following as well.  Consider using the object data type for these.
  * port mapping  (key-value pairs to set the protocol, frontend_port, and backend_port of the load balancer rule)
  * health probe (key-value pairs to set the protocol, port, and path of the load balancer health probe)

Try to write the variables.tf code on your own initially. Compare your code to the solution below (or in the load-balancer/variables.tf file in the solution folder).

<details>

 _<summary>Click to see solution for load balancer module variables</summary>_

```
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
```
</details>

Open the load-balancer main.tf file and use these variables to populate the corresponding arguments in the resources in the file.

Within the “load-balancer” directory, create a file called outputs.tf”.

Go through the root module's file to see where load balancer attributes are referenced.  These are candidates for output values from the load balancer module.

In the load balancer outputs.tf file, add outputs for the following:
  * load balancer backend address pool id
  * load balancer public ip address

Try to write this on your own initially.  Compare your code to the solution below (or in the load-balancer/outputs.tf file in the solution folder).

<details>

 _<summary>Click to see solution for load balancer module outputs</summary>_

```
output "backend_address_pool_id" {
  value = azurerm_lb_backend_address_pool.lab.id
}

output "public_ip_address" {
  value = azurerm_public_ip.lab-lb.ip_address
}
```
</details>

### Modify code to call the new module

Open the file vm-cluster.tf in the root module.  Add a call to the load balancer module, setting argument values corresponding to the input variables for the load balancer.  The module source should be "./modules/load-balancer".

Try writing this on your own first. Compare your code to the solution below (or in the vm-cluster.tf file in the solution folder).

<details>

 _<summary>Click to see solution for load balancer module outputs</summary>_

```
module "load-balancer" {
  source = "./load-balancer"

  location            = local.region
  resource_group_name = azurerm_resource_group.lab.name
  tags                = local.common_tags
  port_mapping = {
    protocol      = "Tcp"
    frontend_port = 80
    backend_port  = 80
  }
  health_probe = {
    protocol     = "Http"
    port         = 80
    request_path = "/"
  }
}
```
</details>

In the root module, you now need to use the module outputs to replace references to the load balancer attributes.

* Update the reference to backend_address_pool_id in vm-cluster.tf
* Update the reference to load-balancer-public-ip in outputs.tf in the root module.

### Execute terraform commands

To run the terraform commands, you must be in the root module's directory.
```
cd ..
pwd
```
Verify that you are in the /tflabs folder.

Let's now validate the code you've written.  If you run terraform validate at this point, you will get an error that you need to run terraform init first.  Do you recall why this is necessary?

Run terraform init.
```
terraform init
```

Run terraform validate and fix errors as appropriate.
```
terraform validate
```

Run terraform plan. You will see that Terraform wants to replace the load balancer and various ancillary resources.
```
terraform plan
```

![Terraform Plan - LB Module](./images/tf-plan-lb-module1.png "Terraform Plan - LB Module")

![Terraform Plan - LB Module](./images/tf-plan-lb-module2.png "Terraform Plan - LB Module")


Run terraform apply:
```
terraform apply
```

:information_source: NOTE: You may get an error that a resource was not able to be created since its predecessor was not yet deleted (i.e., name conflict).  You should be able to just re-run terraform apply again since the resources should have been fully destroyed by the conclusion of the first apply.

![Terraform Apply - LB Module](./images/tf-apply-lb-module1.png "Terraform Apply - LB Module")

![Terraform Apply - LB Module](./images/tf-apply-lb-module2.png "Terraform Apply - LB Module")

### Install HTTP server on VMs

Now let’s make sure the load balancer works.

You can then go to a browser and use the public IP of the load balancer to hit the HTTP server on the VMs.

![Browser - IP Address of LB/VMs](./images/http-lb.png "Browser - IP Address of LB/VMs")
