# Data Sources

Lab Objective:
- Use a data source to access data from an existing resource

## Lab

Let’s imagine that the database administrators set up database credentials separate from your infrastructure.  In that case, you would not be able to access your own key vault for the database password, but rather would need to access a key vault managed by the database admins.

In this lab we will use a data source to access the key vault rather than accessing it directly as a resource.

Open database.tf for edit.

* Add a data source for azurerm_key_vault_secret.

* Use the data source to set the administrator_login_password argument for the database.

Run terraform validate:
```
terraform validate
```

Run terraform plan:
```
terraform plan
```

In this case, Terraform plan will not find any changes to apply since the password has not changed.

![Terraform Plan - Data source](./images/tf-plan-data.png "Terraform Plan - Data source")
