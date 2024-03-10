data "aws_s3_bucket" "src_bucket" {
  bucket = var.s3_src_bucket_name
}
