data "linode_object_storage_cluster" "dest_bucket_cluster" {
  id = "${var.linode_region}-1"
}

resource "linode_object_storage_bucket" "dest_bucket" {
  cluster = data.linode_object_storage_cluster.dest_bucket_cluster.id
  label   = "dest-bucket"
}

resource "linode_object_storage_key" "key" {
  label = "obj-storage-key-for-sync"
  bucket_access {
    bucket_name = linode_object_storage_bucket.dest_bucket.label
    permissions = "read_write"
    cluster     = data.linode_object_storage_cluster.dest_bucket_cluster.id
  }
}
