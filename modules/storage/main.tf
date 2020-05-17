resource "google_storage_bucket" "default" {
  count         = var.enabled ? 1 : 0
  name          = var.name 
  location      = var.location
  project       = var.project
  storage_class = var.storage_class
  force_destroy = var.force_destroy


  lifecycle_rule {
    action {
      type          = var.action_type
      storage_class = var.action_storage_class
    }

    condition {
      age                   = var.age
      created_before        = var.created_before
      with_state            = var.with_state
      matches_storage_class = var.matches_storage_class
      num_newer_versions    = var.num_newer_versions
    }
  }

  versioning {
    enabled = var.versioning_enabled
  }

  encryption {
    default_kms_key_name = var.kms_key_name
  }
}

resource "google_storage_bucket_acl" "default" {
  count       = var.enabled ? 1 : 0
  default_acl = var.default_acl
  bucket      = join("", google_storage_bucket.default.*.name)
  role_entity = compact(var.role_entity)
}
