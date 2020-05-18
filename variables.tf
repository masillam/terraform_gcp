variable "project_id" {
  description = "The ID of the project where this VPC will be created"
}

variable "network_name" {
  description = "The name of the network being created"
}

variable "routing_mode" {
  type        = string
  default     = "GLOBAL"
  description = "The network routing mode (default 'GLOBAL')"
}

variable "shared_vpc_host" {
  type        = bool
  description = "Makes this project a Shared VPC host if 'true' (default 'false')"
  default     = false
}


variable "description" {
  type        = string
  description = "An optional description of this resource. The resource must be recreated to modify this field."
  default     = ""
}


variable "auto_create_subnetworks" {
  type        = bool
  default     = false
}


variable "subnets" {
  type        = list(map(string))
  description = "The list of subnets being created"


default = [
{
            subnet_name           = "subnet-01"
            subnet_ip             = "10.10.10.0/24"
            subnet_region         = "us-west1"
        }
  ]

}


variable "gcp_project_id" {
  type = string

  description = "The ID of the project"
  default = "flask-app-277113"
}

variable "cluster_name" {
  type = string

  description = "The name of the cluster uniq within the project and zone" 
  default = "clusternew"
}

variable "gcp_location" {
  type = string

  default = "europe-west1" 
}

variable "daily_maintenance_window_start_time" {
  type = string

  description = "The start time of the 4 hour window for daily maintenance operations"
  default = "03:00"
}

variable "node_pools" {
  type = list(map(string))

  description = "the list of node pool configurations, each should include"

default =  [
  {
    name                       = "default"
    initial_node_count         = 1
    autoscaling_min_node_count = 2
    autoscaling_max_node_count = 3
    management_auto_upgrade    = true
    management_auto_repair     = true
    node_config_machine_type   = "n1-standard-1"
    node_config_disk_type      = "pd-standard"
    node_config_disk_size_gb   = 100
    node_config_preemptible    = false
  }
]

}

variable "vpc_network_name" {
  type = string

  description = "GCP network to which the cluster is connected" 
  default = "vpc-network"
}

variable "vpc_subnetwork_name" {
  type = string

  description = "subnetwork in which the cluster's instances are launched"
  default = "vpc-subnetwork"
}

variable "cluster_secondary_range_name" {
  type = string
  description = "The name of the secondary range to be used as for the cluster CIDR block"
  default = "pods"
}

variable "services_secondary_range_name" {
  type = string

  description = "The name of the secondary range to be used as for the services CIDR block"
  default = "services"
}

variable "master_ipv4_cidr_block" {
  type    = string
  default = "172.16.0.0/28"
  description = "IP range in CIDR notation to use for the hosted master network"
}

variable "access_private_images" {
  type    = string
  default = "false"
}

variable "http_load_balancing_disabled" {
  type    = string
  default = "false"
}

variable "master_authorized_networks_cidr_blocks" {
  type = list(map(string))

  default = [
    {
      cidr_block = "0.0.0.0/0"
      display_name = "default"
    }
  ]

}
