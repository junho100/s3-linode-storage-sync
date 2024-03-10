resource "linode_instance" "backend" {
  count     = 1
  label     = "backend"
  image     = "linode/ubuntu22.04"
  region    = var.linode_region
  type      = "g6-nanode-1"
  root_pass = var.instance_password

  stackscript_id = linode_stackscript.add_proxy.id
  stackscript_data = {
    SRC_REGION             = var.aws_region
    SRC_BUCKET             = data.aws_s3_bucket.src_bucket.bucket
    SRC_ACCESSKEY          = module.s3_readonly_iam_user.iam_access_key_id
    SRC_SECRETKEY_PASSWORD = module.s3_readonly_iam_user.iam_access_key_secret
    // jp-osa-1
    DEST_REGION             = "${var.linode_region}-1"
    DEST_BUCKET             = linode_object_storage_bucket.dest_bucket.label
    DEST_ACCESSKEY          = linode_object_storage_key.key.access_key
    DEST_SECRETKEY_PASSWORD = linode_object_storage_key.key.secret_key
    RCLONE_FREQUENCY_MINUTE = var.rclone_frequency_minute
  }
}
