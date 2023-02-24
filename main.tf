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

  enrichment_parameters= {
    input_template = var.input_template
  }

  source_parameters = merge(lookup(local.source_parameters_map, var.source_type), local.filter_map)
}

resource "awscc_pipes_pipe" "pipe" {
  name     = var.name
  role_arn = var.role_arn

  source   = var.source_arn
  source_parameters = local.source_parameters

  enrichment = var.enrichment_arn
  enrichment_parameters = local.enrichment_parameters

  target = var.target_arn
}

