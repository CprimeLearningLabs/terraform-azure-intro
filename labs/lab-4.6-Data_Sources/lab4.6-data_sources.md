# Data Sources

Lab Objective:
- Use a data source to access data from an existing resource

## Preparation

If you did not complete lab 4.5, you can simply copy the code from that lab (and do terraform apply) as the starting point for this lab.

## Lab

Let’s imagine that the database administrators set up database credentials separate from your infrastructure.  In that case, you would not be able to access your own key vault for the database password, but rather would need to access a key vault managed by the database admins.

In this lab we will use a data source to access the key vault rather than accessing it directly as a resource.  (In real practice, the data source would be a key vault managed by a separate infrastructure configuration rather than referencing the same key vault from our own configuration.)

Open database.tf for edit.

Go to the Terraform documentation and find the documentation for the azurerm_key_vault_secret data resource.  (Be sure you find the **data** resource rather than a standard resource.)  Based on the documentation, try adding the data resource to the database.tf file.  Compare your code to the solution below (or in the database.tf file in the solution folder).

<details>

 _<summary>Click to see solution for data resource</summary>_

```
data "azurerm_key_vault_secret" "creds" {
  name         = "dbpassword"
  key_vault_id = azurerm_key_vault.lab.id
  depends_on   = [azurerm_key_vault_secret.lab-db-pwd]
}
```
</details>

In the solution, notice that an explicit depends_on argument is included.  Can you recall from an earlier lecture on processing order dependencies why this is needed?  (Of course, if the data source were truly from an external configuration, then the secret would already exist.)

Now set the administrator_login_password argument in the <code>azurerm_postgresql_server</code> resource to use a reference to the data resource value.

<details>

 _<summary>Click to see solution for referencing the data source value</summary>_

```
  administrator_login_password  = data.azurerm_key_vault_secret.creds.value
```
Did you remember to include the "data" prefix in the reference?
</details>

Run terraform validate:
```
terraform validate
```

Run terraform plan.  Verify that Terraform plan will not find any changes to apply to the infrastructure since the password has not changed.  But the plan does identify that a new data resource needs to be read as part of the Terraform state.
```
terraform plan
```

![Terraform Plan - Data source](./images/tf-plan-data.png "Terraform Plan - Data source")

To add the data resource as part of the managed state, run terraform apply.

```
terraform apply
```

If you read the Terraform documentation on the azurerm_key_vault_secret data resource, you would see a warning that the secret will be stored as plain text in the state file.  Fortunately we are storing the state in an Azure backend that is encrypted.
