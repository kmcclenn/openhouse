variable "resource_group_name" {
    type = string
    default = "resources"
    description = "Name of the resource group."
}

variable "resource_group_location" {
  type        = string
  default     = "westus"
  description = "Location of the resource group."
}

variable "k8s_cluster_name" {
    type = string
    description = "The name of the Azure k8s cluster."
    default = "openhouse_cluster"
}