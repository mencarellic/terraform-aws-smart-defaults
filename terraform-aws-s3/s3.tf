resource "aws_s3_bucket_public_access_block" "this" {
  bucket                  = aws_s3_bucket.this.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket" "this" {
  bucket = local.bucket.name
  acl    = local.bucket.acl

  versioning {
    enabled = local.bucket.versioning
  }

  dynamic "logging" {
    for_each = local.bucket.logging.target_bucket != null ? [local.bucket.logging.target_bucket] : []

    content {
      target_bucket = local.bucket.logging.target_bucket
      target_prefix = local.bucket.logging.target_prefix
    }
  }

  lifecycle_rule {
    id      = local.bucket.name
    enabled = local.bucket.lifecycle.enabled

    abort_incomplete_multipart_upload_days = local.bucket.lifecycle.abort_incomplete_multipart_upload_days

    dynamic "noncurrent_version_transition" {
      for_each = local.bucket.lifecycle.noncurrent_transition != {} ? local.bucket.lifecycle.noncurrent_transition : {}

      content {
        days          = noncurrent_version_transition.value
        storage_class = noncurrent_version_transition.key
      }
    }

    dynamic "noncurrent_version_expiration" {
      for_each = local.bucket.lifecycle.noncurrent_expiration != "" ? [local.bucket.lifecycle.noncurrent_expiration] : []

      content {
        days = local.bucket.lifecycle.noncurrent_expiration
      }
    }

    dynamic "expiration" {
      for_each = local.bucket.lifecycle.expired_object_delete_marker ? [local.bucket.lifecycle.expired_object_delete_marker] : []

      content {
        expired_object_delete_marker = local.bucket.lifecycle.expired_object_delete_marker
      }
    }

  }

  tags = merge(
    {
      "Name" = local.bucket.name,
    },
    var.tags
  )
}
