## terraform-azure-cosmosdb-mongodb-ru

A Terraform module to deploy Azure CosmosDB MongoDB databases with support for both autoscale and manual throughput modes. This module allows you to define multiple databases, configure throughput, and optionally set up private endpoints.

---

## Features

*   **Create multiple CosmosDB MongoDB databases** with a single variable.
*   **Support for autoscale and manual throughput** settings.
*   **Private endpoint support** for secure network access.
*   **Flexible variable-driven configuration**.

---

## Usage

```plaintext
module "cosmosdb_mongodb" {
  source = "github.com/azure-terraform-module/terraform-azure-cosmosdb-mongodb-ru"

  resource_group_name = "your-resource-group"
  account_name        = "your-cosmosdb-account"

  databases = [
    {
      name         = "ahihi"
      scaling_mode = "auto"
      throughput   = 400
    },
    {
      name         = "huhu"
      scaling_mode = "manual"
      throughput   = 400
    }
  ]
}
```

### Network Mode

#### Public network access:

*   **Meaning:**  
    This setting controls how your Cosmos DB account can be accessed over the public internet.
*   **Use case:**  
    This is the least restrictive option and is generally **not recommended for production** due to security risks, as anyone with the connection string can attempt to access your database.
*   **Example:**

```plaintext
module "cosmos-mongodb" {
  source  = "github.com/azure-terraform-module/terraform-azure-cosmosdb-mongodb-ru?ref=master"
  location            = "Australia East"
  resource_group_name = "nimtechnology"
  mongodb_name = "elearning"
  geo_locations = ["Australia East"]
}
```

#### Selected networks

*   **Meaning:**  
    Allow instances in a specific VNet or its subnets to access MongoDB's public IP via the Azure priority network instead of the Internet (NAT Gateway). You must enable and configure service mode in the subnet settings.
*   **Use case:**  
    This is the least restrictive option and is generally **not recommended for production** due to security risks, as anyone with the connection string can attempt to access your database.
*   **Example:**

```plaintext
module "vnet" {
  source = "azure-terraform-module/vnet/azure"
  version = "0.0.2"
  vnet_name           = "elearning"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  address_space       = ["10.0.0.0/16"]
  subnet_prefixes = ["10.0.1.0/24","10.0.2.0/24"]
}
module "cosmos-mongodb" {
  source  = "github.com/azure-terraform-module/terraform-azure-cosmosdb-mongodb-ru?ref=master"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  mongodb_name = "elearning"
  geo_locations = ["Australia East"]
  network_mode = "service"
  subnet_ids = module.vnet.subnet_ids
}
```

#### Private network access:

Public access will be disabled.  
Access to MongoDB instances is available through the IP addresses of the subnets in the virtual network (VNet).

```plaintext
module "vnet" {
  source = "azure-terraform-module/vnet/azure"
  version = "0.0.2"
  vnet_name           = "elearning"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  address_space       = ["10.0.0.0/16"]
  subnet_prefixes = ["10.0.1.0/24","10.0.2.0/24"]
}

module "cosmos-mongodb" {
  source  = "github.com/azure-terraform-module/terraform-azure-cosmosdb-mongodb-ru?ref=master"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  mongodb_name = "elearning"
  geo_locations = ["Australia East"]
  network_mode = "private"
  subnet_ids = [module.vnet.subnet_ids[0]]
  vnet_ids = [module.vnet.vnet_id]
}
```

##### How to get the private IP and private domain (FQDN) of your CosmosDB MongoDB:

1.  **Go to your CosmosDB resource** in the Azure Portal.
2.  Click **Networking** in the left menu.
3.  Select the **Private access** tab.
4.  Click your private endpoint name.
5.  In the private endpoint menu, go to **DNS configuration**.

**You’ll see:**

*   **Private IP addresses** (e.g., 10.0.1.4)
*   **Private FQDNs** (e.g., elearning.mongo.cosmos.azure.com)

Use these for secure, private connections from your VNet.

---

## Input Variables

Please refer:

---

## Outputs

| Name | Description |
| --- | --- |
| `mongo_database_names` | List of created MongoDB database names. |

---

## Files

*   `c1-providers.tf` – Provider configuration.
*   `c2-variables.tf` – Input variable definitions.
*   `c3-locals.tf` – Local values for internal logic.
*   `c4-cosmosdb-mongodb-ru.tf` – CosmosDB MongoDB resource definitions.
*   `c5-private-endpoint.tf` – Private endpoint resources (optional).
*   `README.md` – This documentation.

---

## Requirements

*   Terraform >= 0.13
*   Azure Provider >= 2.0

---

## License

MIT

---

## References

*   [Terraform Azure Provider Documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cosmosdb_account)
*   [Azure CosmosDB Documentation](https://docs.microsoft.com/en-us/azure/cosmos-db/introduction)