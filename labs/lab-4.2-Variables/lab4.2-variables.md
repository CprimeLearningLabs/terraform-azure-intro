# Variables

Lab Objective:
- Add input variables to your configuration

# Preparation

If you did not complete lab 3.5, you can simply copy the code from that lab (and do terraform apply) as the starting point for this lab.

# Lab

First, think about what you might want to parameterize in the configuration you have defined so far.

:question: What variations might you want to support?  Should there be a default value for some parameters, and which should be required?

Create a file called variables.tf

For this lab, we will create variables for the following:
-	Region
- VM password
-	Database storage amount

Try your hand at writing the variable declarations in variables.tf.  If you are ambitious, try also to write a validation block to verify the db storage size is greater than or equal to 5120 and is a multiple of 1024.   Run terraform validate to check for syntax errors.

Compare your code to the variables.tf file in the solution folder.

Now, use a variable reference to replace the corresponding target expressions in the configuration files.  There should be three places:

- Set the region local value in main.tf with var.region
- Set the admin_password value in vm.tf with var.vm_password
- Set the storage_mb value in database.tf with var.db_storage

Run terraform validate to check for errors.

### Setting the Variable Values

Create a file called terraform.tfvars

Set the values for the variables in that file.  Keep the region the same as before to avoid recreating the entire infrastructure.  Also, keeping the password the same as before will avoid re-creating the virtual machine.  (If you forgot the VM password, you can look in the solution folder of a previous lab.)   Change the database storage amount to a new value.

```
region = "westus2"
db_storage = 6144
vm_password = "<PASSWORD>"
```

:bangbang: NOTE:  Storing passwords in a file is a strongly discouraged practice.  The virtual machine really should be using an SSH key for access instead of a password.  Including a password in the variables file is only for the convenience of this lab and should not be done in actual practice.

Run terraform plan:
```
terraform plan
```

:information_source: **Changing the database storage can be updated in place. If you changed the VM password, the virtual machine will need to be re-created.**

![Terraform Plan - after variable addition](./images/tf-plan-vars.png "Terraform Plan - after variable addition")

Run terraform apply:
```
terraform apply
```

Confirm you can SSH into the machine.

:information_source: If you changed the password, you will need to get the IP Address of re-created VM via the Azure Console or by running _terraform_show_.
```
ssh adminuser@<IP ADDDRESS OF VM>
<vm_password>
```
