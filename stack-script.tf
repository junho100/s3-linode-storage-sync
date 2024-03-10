resource "linode_stackscript" "rclone_sync" {
  label       = "rclone-sync"
  description = "rclone s3 - object storage sync script"
  script      = file("./files/s3-linode-sync.sh")
  images      = ["linode/ubuntu22.04"]
}
