variable "project_id" {
  type = string
  description = "Project ID within GCP"
}

variable "gkeregionprimary" {
  type        = string
  description = "Primary Region"
}

variable "gkeregionsecondary" {
  type        = string
  description = "Secondary Region"
}

variable "fqdn" {
  type        = string
  description = "FQDN for the Private Edition Apps"
}

variable "gkecluster" {
  type = string
  description = "GKE Cluster Name"
}

variable "emailaddress" {
  type = string
  description = "Email Address to use for DNS zone"
}

variable "storageBucketName" {
  type = string
  description = "Name of the Terraform Storage Bucket"
}
