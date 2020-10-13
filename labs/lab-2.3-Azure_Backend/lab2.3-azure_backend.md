# Using Azure Backend

Lab Objective:
- Save Terraform state to backend in Azure storage

## Preparation

If you did not complete lab 2.2, you can simply copy the code from that lab as the starting point for this lab.

## Lab

Since we will want to show migration of state from local to remote, run terraform apply to ensure there is current state:

```
terraform apply
```

(If there was current state already, then the apply will show nothing to create; otherwise accept the changes to apply.)

![Nonempty Terraform state](./images/tf-show-apply.png "Nonempty Terraform state")

### Authenticate to Azure CLI

If you are running this lab in the Azure Cloud Shell, then Azure CLI authentication was already automatically done when you opened Cloud Shell.  

> If you are running this lab from a machine, then you will need to use the Azure CLI to authenticate by typing "az login" which will direct you to a browser login page to log into the Azure CLI.

### Update Terraform configuration

We will be configuring a backend to store the terraform state in an Azure storage blob.  The storage account and container were already set up prior to the class.  The backend state will be stored in a new blob created in the container.

Edit “main.tf” to add a backend for Azure.  Add the following as a sub-block in the terraform block.  (You can view the complete file in the /code folder.)
*Make sure you are putting it in the correct location in the file (inside the terraform block) and not at the end of the file or another arbitrary location.*

```
  backend "azurerm" {
    resource_group_name  = "terraform-course-backend"
    container_name       = "tfstate"
    key                  = "cprime.terraform.labs.tfstate"
  }
```


This will now direct the state to be saved in Azure.  Since you changed the backend configuration, you will need to run terraform init again.  Run:

```
terraform init
```

Terraform will prompt you for the storage account.  The storage account name will be "aztfcoursebackendNN" where NN is your user number.  For example, if your username for logging into Azure was "user05" then the storage account name would be "aztfcoursebackend05".  

> If you enter the wrong storage account name, you will get an error.  Unfortunately you will not be able to just re-run terraform init.  You must first remove the .terraform subdirectory by typing "rm -rf .terraform".  You can then re-run terraform init.

Terraform will then prompt you to migrate the existing state from the “terraform.tfstate” file to the backend in Azure.

Type “yes”

![Terraform init with remote backend](./images/tf-init.png "Terraform init with remote backend")

Terraform will copy the state to Azure.  The state will be saved in a new Azure storage blob referenced in the backend configuration above.

Notice that the terraform.tfstate file is left remaining.  You should delete the file to avoid confusion.

```
rm terraform.tfstate*
```

To confirm that the state still exists, use terraform show.

```
terraform show
```

![Terraform remote state](./images/tf-remote-state.png "Terraform remote state")
