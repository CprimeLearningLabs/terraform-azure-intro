terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.40"
    }
  }
  backend "azurerm" {
    resource_group_name  = "terraform-class-setup"
    storage_account_name = "aztfclasssetupbackend"
    container_name       = "tfstate"
    key                  = "cprime.terraform.class-setup.tfstate"
  }
  required_version = "~> 1.0.0"
}

###########################################
#  Providers - one per subscription
###########################################

provider "azurerm" {
  alias = "sub00"
  subscription_id = var.subscription-ids["00"]
  features {}
}
provider "azurerm" {
  alias = "sub01"
  subscription_id = var.subscription-ids["01"]
  features {}
}
provider "azurerm" {
  alias = "sub02"
  subscription_id = var.subscription-ids["02"]
  features {}
}
provider "azurerm" {
  alias = "sub03"
  subscription_id = var.subscription-ids["03"]
  features {}
}
provider "azurerm" {
  alias = "sub04"
  subscription_id = var.subscription-ids["04"]
  features {}
}
provider "azurerm" {
  alias = "sub05"
  subscription_id = var.subscription-ids["05"]
  features {}
}
provider "azurerm" {
  alias = "sub06"
  subscription_id = var.subscription-ids["06"]
  features {}
}
provider "azurerm" {
  alias = "sub07"
  subscription_id = var.subscription-ids["07"]
  features {}
}
provider "azurerm" {
  alias = "sub08"
  subscription_id = var.subscription-ids["08"]
  features {}
}
provider "azurerm" {
  alias = "sub09"
  subscription_id = var.subscription-ids["09"]
  features {}
}
provider "azurerm" {
  alias = "sub10"
  subscription_id = var.subscription-ids["10"]
  features {}
}
provider "azurerm" {
  alias = "sub11"
  subscription_id = var.subscription-ids["11"]
  features {}
}
provider "azurerm" {
  alias = "sub12"
  subscription_id = var.subscription-ids["12"]
  features {}
}
provider "azurerm" {
  alias = "sub13"
  subscription_id = var.subscription-ids["13"]
  features {}
}
provider "azurerm" {
  alias = "sub14"
  subscription_id = var.subscription-ids["14"]
  features {}
}
provider "azurerm" {
  alias = "sub15"
  subscription_id = var.subscription-ids["15"]
  features {}
}
provider "azurerm" {
  alias = "sub16"
  subscription_id = var.subscription-ids["16"]
  features {}
}
provider "azurerm" {
  alias = "sub17"
  subscription_id = var.subscription-ids["17"]
  features {}
}
provider "azurerm" {
  alias = "sub18"
  subscription_id = var.subscription-ids["18"]
  features {}
}
provider "azurerm" {
  alias = "sub19"
  subscription_id = var.subscription-ids["19"]
  features {}
}
provider "azurerm" {
  alias = "sub20"
  subscription_id = var.subscription-ids["20"]
  features {}
}
provider "azurerm" {
  alias = "sub21"
  subscription_id = var.subscription-ids["21"]
  features {}
}
provider "azurerm" {
  alias = "sub22"
  subscription_id = var.subscription-ids["22"]
  features {}
}
provider "azurerm" {
  alias = "sub23"
  subscription_id = var.subscription-ids["23"]
  features {}
}
provider "azurerm" {
  alias = "sub24"
  subscription_id = var.subscription-ids["24"]
  features {}
}
provider "azurerm" {
  alias = "sub25"
  subscription_id = var.subscription-ids["25"]
  features {}
}

################################################################################
# Create a storage account and container for backend state in each subscription.
# (Unfortunatelly Terraform does not suport iterating over providers.)
################################################################################

module "storage-00" {
  source    = "./storage"
  providers = {azurerm = azurerm.sub00}
  location  = var.location
  sequence  = "00"
}
module "storage-01" {
  source    = "./storage"
  providers = {azurerm = azurerm.sub01}
  location  = var.location
  sequence  = "01"
}
module "storage-02" {
  source    = "./storage"
  providers = {azurerm = azurerm.sub02}
  location  = var.location
  sequence  = "02"
}
module "storage-03" {
  source    = "./storage"
  providers = {azurerm = azurerm.sub03}
  location  = var.location
  sequence  = "03"
}
module "storage-04" {
  source    = "./storage"
  providers = {azurerm = azurerm.sub04}
  location  = var.location
  sequence  = "04"
}
module "storage-05" {
  source    = "./storage"
  providers = {azurerm = azurerm.sub05}
  location  = var.location
  sequence  = "05"
}
module "storage-06" {
  source    = "./storage"
  providers = {azurerm = azurerm.sub06}
  location  = var.location
  sequence  = "06"
}
module "storage-07" {
  source    = "./storage"
  providers = {azurerm = azurerm.sub07}
  location  = var.location
  sequence  = "07"
}
module "storage-08" {
  source    = "./storage"
  providers = {azurerm = azurerm.sub08}
  location  = var.location
  sequence  = "08"
}
module "storage-09" {
  source    = "./storage"
  providers = {azurerm = azurerm.sub09}
  location  = var.location
  sequence  = "09"
}
module "storage-10" {
  source    = "./storage"
  providers = {azurerm = azurerm.sub10}
  location  = var.location
  sequence  = "10"
}
module "storage-11" {
  source    = "./storage"
  providers = {azurerm = azurerm.sub11}
  location  = var.location
  sequence  = "11"
}
module "storage-12" {
  source    = "./storage"
  providers = {azurerm = azurerm.sub12}
  location  = var.location
  sequence  = "12"
}
module "storage-13" {
  source    = "./storage"
  providers = {azurerm = azurerm.sub13}
  location  = var.location
  sequence  = "13"
}
module "storage-14" {
  source    = "./storage"
  providers = {azurerm = azurerm.sub14}
  location  = var.location
  sequence  = "14"
}
module "storage-15" {
  source    = "./storage"
  providers = {azurerm = azurerm.sub15}
  location  = var.location
  sequence  = "15"
}
module "storage-16" {
  source    = "./storage"
  providers = {azurerm = azurerm.sub16}
  location  = var.location
  sequence  = "16"
}
module "storage-17" {
  source    = "./storage"
  providers = {azurerm = azurerm.sub17}
  location  = var.location
  sequence  = "17"
}
module "storage-18" {
  source    = "./storage"
  providers = {azurerm = azurerm.sub18}
  location  = var.location
  sequence  = "18"
}
module "storage-19" {
  source    = "./storage"
  providers = {azurerm = azurerm.sub19}
  location  = var.location
  sequence  = "19"
}
module "storage-20" {
  source    = "./storage"
  providers = {azurerm = azurerm.sub20}
  location  = var.location
  sequence  = "20"
}
module "storage-21" {
  source    = "./storage"
  providers = {azurerm = azurerm.sub21}
  location  = var.location
  sequence  = "21"
}
module "storage-22" {
  source    = "./storage"
  providers = {azurerm = azurerm.sub22}
  location  = var.location
  sequence  = "22"
}
module "storage-23" {
  source    = "./storage"
  providers = {azurerm = azurerm.sub23}
  location  = var.location
  sequence  = "23"
}
module "storage-24" {
  source    = "./storage"
  providers = {azurerm = azurerm.sub24}
  location  = var.location
  sequence  = "24"
}
module "storage-25" {
  source    = "./storage"
  providers = {azurerm = azurerm.sub25}
  location  = var.location
  sequence  = "25"
}
