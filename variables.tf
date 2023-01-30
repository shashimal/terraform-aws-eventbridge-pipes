variable "name" {
  default = ""
}

variable "role_arn" {
  default = ""
}

variable "source_arn" {
  default = ""
}

variable "target_arn" {
  default = ""
}

variable "source_type" {
  default = ""
}

variable "dynamo_db_stream_parameters" {
  type = object({
    starting_position                  = string
    batch_size                         = optional(number)
    dead_letter_config                 = optional(object({}))
    maximum_batching_window_in_seconds = optional(number)
    maximum_record_age_in_seconds      = optional(number)
    maximum_retry_attempts             = optional(number)
    on_partial_batch_item_failure      = optional(string)
    parallelization_factor             = optional(number)
  })
  default = null
}

variable "sqs_queue_parameters" {
  type = object({
    batch_size = optional(number)
    maximum_batching_window_in_seconds = optional(string)
  })
  default = null
}

variable "source_filters" {
  default = []
}
