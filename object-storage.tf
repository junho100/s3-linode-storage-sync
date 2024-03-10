data "linode_object_storage_cluster" "dest_bucket_cluster" {
  // jp-osa-1
  id = "${var.linode_region}-1"
}

resource "linode_object_storage_bucket" "dest_bucket" {
  cluster    = "${var.linode_region}-1"
  label      = "dest-bucket"
  depends_on = [data.linode_object_storage_cluster.dest_bucket_cluster]
}

resource "linode_object_storage_key" "key" {
  label = "obj-storage-key-for-sync"
  bucket_access {
    bucket_name = "dest-bucket"
    permissions = "read_write"
    // jp-osa-1
    cluster = "${var.linode_region}-1"
  }
  depends_on = [linode_object_storage_bucket.dest_bucket]
}
