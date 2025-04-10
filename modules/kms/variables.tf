variable "environment" {
  description = "Environment name (e.g., dev, demo)"
  type        = string
}

variable "key_name" {
  description = "Name of the KMS key"
  type        = string
}

variable "description" {
  description = "Description of the KMS key"
  type        = string
}

variable "deletion_window_in_days" {
  description = "Duration in days after which the key is deleted after destruction of the resource"
  type        = number
  default     = 30
}

variable "enable_key_rotation" {
  description = "Specifies whether key rotation is enabled"
  type        = bool
  default     = true
}

variable "key_usage" {
  description = "Specifies the intended use of the key (ENCRYPT_DECRYPT or KEY_AGREEMENT)"
  type        = string
  default     = "ENCRYPT_DECRYPT"
}

variable "tags" {
  description = "A map of tags to assign to the key"
  type        = map(string)
  default     = {}
}