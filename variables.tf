variable "linode_token" {
  description = "The Linode API token"
  type        = string
}

variable "linode_region" {
  description = "The Linode region"
  type        = string
}

variable "aws_region" {
  description = "The AWS region"
  type        = string
}

variable "aws_access_key" {
  description = "The AWS access key"
  type        = string
}

variable "aws_secret_key" {
  description = "The AWS secret key"
  type        = string
}

variable "s3_src_bucket_name" {
  description = "The source S3 bucket name"
  type        = string
}

variable "instance_password" {
  description = "The password for the Linode instances"
  type        = string
}

variable "rclone_frequency_minute" {
  description = "The frequency of the Rclone sync in minutes"
  type        = number
}
