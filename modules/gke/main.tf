locals {
  gcp_location_parts = split("-", var.gcp_location)
  gcp_region         = format("%s-%s", local.gcp_location_parts[0], local.gcp_location_parts[1])
}

resource "google_container_cluster" "cluster" {
  location = var.gcp_location
  name = var.cluster_name
  min_master_version = "latest"

  maintenance_policy {
    daily_maintenance_window {
      start_time = var.daily_maintenance_window_start_time
    }
  }

  # A set of options for creating a private cluster.
  private_cluster_config {
    enable_private_endpoint = false
    enable_private_nodes = true
    master_ipv4_cidr_block = var.master_ipv4_cidr_block
  }

  network_policy {
    enabled = true
    provider = "CALICO"
  }

  master_auth {
    username = ""
    password = ""

    client_certificate_config {
      issue_client_certificate = false
    }
  }

  addons_config {
    http_load_balancing {
      disabled = var.http_load_balancing_disabled
    }

    network_policy_config {
      disabled = false
    }
  }

  network    = var.vpc_network_name
  subnetwork = var.vpc_subnetwork_name

  ip_allocation_policy {
    cluster_secondary_range_name  = var.cluster_secondary_range_name
    services_secondary_range_name = var.services_secondary_range_name
  }

  remove_default_node_pool = true

  initial_node_count = 1

  master_authorized_networks_config {
    dynamic "cidr_blocks" {
      for_each = var.master_authorized_networks_cidr_blocks
      content {
        cidr_block   = cidr_blocks.value.cidr_block
        display_name = cidr_blocks.value.display_name
      }
    }
  }

  timeouts {
    update = "20m"
  }
}

resource "google_container_node_pool" "node_pool" {
  location = google_container_cluster.cluster.location

  count = length(var.node_pools)

  name = format("%s-pool", lookup(var.node_pools[count.index], "name", format("%03d", count.index + 1)))

  cluster = google_container_cluster.cluster.name

  initial_node_count = lookup(var.node_pools[count.index], "initial_node_count", 1)

  autoscaling {
    min_node_count = lookup(var.node_pools[count.index], "autoscaling_min_node_count", 2)
    max_node_count = lookup(var.node_pools[count.index], "autoscaling_max_node_count", 3)
  }

  management {
    auto_repair = lookup(var.node_pools[count.index], "auto_repair", true)
    auto_upgrade = lookup(var.node_pools[count.index], "auto_upgrade", true)
  }

  node_config {
    machine_type = lookup(
      var.node_pools[count.index],
      "node_config_machine_type",
      "n1-standard-1",
    )

    service_account = google_service_account.default.email

    disk_size_gb = lookup(
      var.node_pools[count.index],
      "node_config_disk_size_gb",
      100
    )

    disk_type = lookup(
      var.node_pools[count.index],
      "node_config_disk_type",
      "pd-standard",
    )

    preemptible = lookup(
      var.node_pools[count.index],
      "node_config_preemptible",
      false,
    )

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]

    metadata = {
      disable-legacy-endpoints = "true"
    }
  }

  timeouts {
    update = "20m"
  }
}

