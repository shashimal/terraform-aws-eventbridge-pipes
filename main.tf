locals {
  source_parameters_map = {
    dynamodb = {
      dynamo_db_stream_parameters = var.dynamo_db_stream_parameters
    }
    sqs = {
      sqs_queue_parameters = var.sqs_queue_parameters
    }
  }

  filter_map = {
    filter_criteria = {
      filters = var.source_filters
    }
  }

  source_parameters = merge(lookup(local.source_parameters_map, var.source_type), local.filter_map)
}

resource "awscc_pipes_pipe" "pipe" {
  name     = var.name
  role_arn = var.role_arn
  source   = var.source_arn

  source_parameters = local.source_parameters

  target = var.target_arn
}
