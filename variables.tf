variable "s3_bucket_name" {
  description = "Rhodiume package - name of s3 bucket"
  type        = string
  default     = "com.riskfocus.occ.common"
}

variable "s3_bucket_path" {
  description = "Rhodiume package - path of s3 bucket"
  type        = string
  default     = "packages/rhodium/rhodium.zip"
}
