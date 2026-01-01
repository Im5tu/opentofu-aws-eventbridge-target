###########################################################
#  Standard Variables
###########################################################
variable "tags" {
  description = "Tags that are specific to this module"
  type        = map(string)
  default     = {}
}

###########################################################
#  Your variables go below here
###########################################################
variable "name" {
  description = "The name of the rule"
  type        = string
}

variable "event_bus_name" {
  description = "The name of the eventbridge instance to configure against"
  type        = string
}

variable "event_pattern" {
  description = "The pattern to use for matching events to the target"
  type        = string
  default     = null
}

variable "invocation_role_arn" {
  description = "The role to use for all parts of the invocation"
  type        = string
  default     = null
}

variable "invocation_target_arn" {
  description = "The ARN of the target for the rule"
  type        = string
}

variable "description" {
  description = "The description of the rule"
  type        = string
  default     = ""
}

variable "enable_dlq" {
  description = "Whether to create a dead letter queue for failed events"
  type        = bool
  default     = true
}

variable "kms_key_arn" {
  description = "The ARN of the KMS key used to secure the DLQ (if enabled)"
  type        = string
  default     = null
}
