/******************************************
	VPC configuration
 *****************************************/
module "vpc" {
  source                  = "./modules/vpc"
  network_name            = var.network_name
  auto_create_subnetworks = var.auto_create_subnetworks
  routing_mode            = var.routing_mode
  project_id              = var.project_id
  description             = var.description
  shared_vpc_host         = var.shared_vpc_host
}



module "subnets" {
  source           = "./modules/subnets"
  project_id       = var.project_id
  network_name     = module.vpc.network_name
  subnets          = var.subnets
}

module "cluster" {
  source  = "./modules/gke"

  gcp_project_id                         = var.gcp_project_id
  cluster_name                           = var.cluster_name
  gcp_location                           = var.gcp_location
  daily_maintenance_window_start_time    = var.daily_maintenance_window_start_time
  node_pools                             = var.node_pools
  cluster_secondary_range_name           = var.cluster_secondary_range_name
  services_secondary_range_name          = var.services_secondary_range_name
  master_ipv4_cidr_block                 = var.master_ipv4_cidr_block
  access_private_images                  = var.access_private_images
  http_load_balancing_disabled           = var.http_load_balancing_disabled
  master_authorized_networks_cidr_blocks = var.master_authorized_networks_cidr_blocks

  # Refer to the vpc-network and vpc-subnetwork by the name value on the
  # resource, rather than the variable used to assign the name, so that
  # Terraform knows they must be created before creating the cluster

  vpc_network_name    = module.vpc.network_name 
  vpc_subnetwork_name = "subnet-01" 
}