variable "resource_group_name" {
  description = "The name of the resource group where the resources will be created."
  type        = string
}

variable "location" {
  description = "The Azure location where the resources will be created."
  type        = string
}

variable "tags" {
  description = "Tags to assign to the resource."
  type        = map(string)
  default     = {}
}

variable "subnet_ids" {
  description = "The resource ID of the subnet for the private endpoint."
  type        = list(string)
  default     = []
}

variable "private_dns_zone_ids" {
  description = "The resource ID of the private DNS zone for Event Hub."
  type        = list(string)
  default     = []
}

variable "ip_rules" {
  description = "CIDR blocks to allow access to the Event Hub - Only for service endpoints."
  type        = list(string)
  default     = []
}

variable "mongo_version" {
  description = "CIDR blocks to allow access to the Event Hub - Only for service endpoints."
  type        = string
  default     = "7.0"
}

variable "consistency_level" {
  description = "The Consistency Level to use for this CosmosDB Account - can be either `BoundedStaleness`, `Eventual`, `Session`, `Strong` or `ConsistentPrefix`"
  type        = string
  default     = "Session"
}

variable "available_zones" {
  description = "Enabling availability zones increases availability by distributing data across different data centers."
  type        = bool
  default     = true
}

variable "geo_locations" {
  description = <<EOT
Configures the geographic locations where the data is replicated.

The order of locations in this list determines their failover priority:
- The first location in the list will have the highest priority (failover_priority = 0).
- The second location will have failover_priority = 1, and so on.

Example:
  geo_locations = ["East US", "West US", "North Europe"]
EOT
  type        = list(string)
}


variable "total_throughput_limit" {
  description = "The total throughput limit for the Cosmos DB account."
  type        = number
  default     = null
  nullable    = true
}


variable "serverless_mode" {
  description = "If set to true, enables serverless mode for the Cosmos DB account. In serverless mode, the database automatically scales throughput based on usage and you are billed for the resources consumed rather than provisioned throughput."
  type        = bool
  default     = false
}

variable "network_mode" {
  type = string
  validation {
    condition     = contains(["private", "service", "public"], var.network_mode)
    error_message = "network_mode must be one of private, service, or public"
  }
  default = "public"
}

variable "vnet_ids" {
  description = "List of VNet IDs used for linking to Private DNS Zone - Only for private endpoints."
  type        = list(string)
  default     = []
}

variable "mongodb_name" {
  description = "Cosmos DB account name for MongoDB"
  type = string
}

variable "databases" {
  description = <<EOT
List of database configurations. Example:
[
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
Note:   
- scaling_mode must be either "auto" or "manual".
- For "auto", throughput sets the max autoscale RU/s.
- For "manual", throughput sets the fixed RU/s.
EOT
  type = list(object({
    name          = string
    scaling_mode  = string
    throughput    = number
  }))
  default = []
  validation {
    condition = alltrue([
      for db in var.databases : contains(["auto", "manual"], db.scaling_mode)
    ])
    error_message = "scaling_mode must be either 'auto' or 'manual'."
  }
}