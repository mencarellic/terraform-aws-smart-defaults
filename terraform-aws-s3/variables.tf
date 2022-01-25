locals {
  bucket-defaults = {
    name       = null
    acl        = "private"
    versioning = true
    lifecycle = {
      enabled                                = true
      abort_incomplete_multipart_upload_days = 1
      expired_object_delete_marker           = false
      noncurrent_expiration                  = 366
      noncurrent_transition = {
        ONEZONE_IA = 30
        GLACIER    = 60
      }
    }
    logging = {
      target_bucket = null
      target_prefix = null
    }
  }

  bucket = merge(local.bucket-defaults, var.bucket)
}

variable "bucket" {
  description = "Bucket parameters"
  type        = any
  default     = {}
}

variable "tags" {
  description = "Map of tags to add to resources"
  type        = map(string)
  default     = {}
}
