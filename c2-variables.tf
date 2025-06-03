variable "resource_group_name" {
  default     = "terraform-eventhub"
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

variable "network_mode" {
  type = string
  validation {
    condition     = contains(["private", "service", "public"], var.network_mode)
    error_message = "network_mode must be one of private, service, or public"
  }
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