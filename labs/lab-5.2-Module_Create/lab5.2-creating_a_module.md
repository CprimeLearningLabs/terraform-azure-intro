# Creating a Module

Lab Objective
- Convert the load balancer configuration in your code to a module
- Use the new module in your configuration

## Preparation

If you did not complete lab 5.1, you can simply copy the solution code from that lab (and do terraform apply) as the starting point for this lab.

## Lab

### Modify code to implement the module

In this lab we will convert the load balancer configuration to be a module implementation.  We will implement the module as a nested module, though in actual practice this module should probably be a module on its own.

Create a subdirectory called “load-balancer”.
```
mkdir load-balancer
```

#### Load balancer main

Move the “lb.tf” file to the “load-balancer” directory and rename the file “main.tf”.  (Recall that each module should have a main.tf file as the principal configuration entry point.)  Let's make a couple changes to the file.

First, a module should include its provider requirements.  So add the following to the top of the load balancer main.tf.  (Note that we do not add a backend specification or a provider block.)
```
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.40, < 3.0"
    }
  }
  required_version = "~> 0.15.0"
}
```

Second, to avoid a name collision later when you do terraform apply, change the Azure name of the following load balancer resources by adding a "mod-" prefix:
  * azurerm_public_ip:  change name from "aztf-labs-lb-public-ip" to "mod-aztf-labs-lb-public-ip"
  * azurerm_lb: change name from "aztf-labs-loadBalancer" to "mod-aztf-labs-loadBalancer"
  * azurerm_lb_rule:  change name from "aztf-labs-lb-rule" to "mod-aztf-labs-lb-rule"

#### Load balancer variables

Within the “load-balancer” directory, create a file called “variables.tf”.

Go through the **load balancer main.tf** file and look for what arguments will need values passed into the module.  (The load balancer module cannot access the parent resources directly.)  These are candidates for the input variables for the load balancer module.

In the load balancer variables.tf file, add variables for the following:
  * location
  * resource group name
  * tags

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
```
</details>

Open the load-balancer main.tf file and use these variables to populate the corresponding arguments in all of the resources in the file.

#### Load balancer outputs

Within the “load-balancer” directory, create a file called outputs.tf”.

Go through the root module's files to see where load balancer attributes are referenced.  These are candidates for output values from the load balancer module.

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

At this point, you now have a nested module with inputs and outputs defined.  Next, let's use the new module.

### Modify code to call the new module

Open the file vm-cluster.tf in the root module.  Add a call to the load balancer module, setting argument values corresponding to the input variables for the load balancer.  The module source should be "./load-balancer".

Try writing this on your own first. Compare your code to the solution below (or in the vm-cluster.tf file in the solution folder).

<details>

 _<summary>Click to see solution for calling load balancer module</summary>_

```
module "load-balancer" {
  source = "./load-balancer"

  location            = local.region
  resource_group_name = azurerm_resource_group.lab.name
  tags                = local.common_tags
}
```
</details>

In the root module, you now need to use the module outputs to replace references to the load balancer attributes.  Be sure to use the "module" prefix in the references.

* Update the reference to backend_address_pool_id in vm-cluster.tf
* Update the reference to load-balancer-public-ip in outputs.tf in the root module.

### Execute terraform commands

To run the terraform commands, you must be in the root module's directory.  :bangbang: **Verify you are in the root module folder.**  If not, move to that directory.

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
> If you get an error that a resource was not able to be re-created since its predecessor was not yet deleted (i.e., a name conflict), then you may have missed renaming a few resources earlier in this lab.  You should be able to just re-run terraform apply again since the conflicting resources should have been fully destroyed by the conclusion of the first apply.
```
terraform apply
```

### (Optional) Trying out your infrastructure

If you have extra time now or later, you can verify that the load balancer actually works to connect to the clustered VMs.  See the instructions at [Testing Your Cluster](../optional-material/testing_your_cluster.md).  If you already set up the HTTP servers before, you should be able to just hit the load balancer public IP again now.
