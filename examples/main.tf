locals {
  event_filters = [{ pattern = "{ \"copyright\": [\"SPH\"] }" }]
  input_template = "{\"id\": \"<$.body.articleId>\",\"headLine\": \"<$.body.head_line>\", \"date\" : \"<$.body.publishedDate>\"}"

}
module "pipe_dynamodb" {
  source = "../"

  name = "test-pipe2"
  source_type = "dynamodb"
  source_arn = "arn:aws:dynamodb:us-east-1:793209430381:table/test/stream/2023-02-24T17:27:05.455"
  enrichment_arn = "arn:aws:lambda:us-east-1:793209430381:function:aft-process"
  target_arn = "arn:aws:lambda:us-east-1:793209430381:function:aft-process"
  role_arn = aws_iam_role.pipe_dynamodb_iam_role.arn

  dynamo_db_stream_parameters = {
    starting_position = "LATEST"
  }

  source_filters = local.event_filters
  input_template = local.input_template
}

module "pipe_sqs" {
  source = "../"

  name = "test-pipe-sqs"
  source_type = "sqs"
  source_arn = aws_sqs_queue.sqs.arn
  target_arn = "arn:aws:lambda:us-east-1:793209430381:function:aft-process"
  role_arn = aws_iam_role.pipe_sqs_iam_role.arn
  enrichment_arn = "arn:aws:lambda:us-east-1:793209430381:function:aft-process"
  input_template = local.input_template
  source_filters = local.event_filters
}

resource "aws_iam_role" "pipe_sqs_iam_role" {
  name = "pipe-sqs-role"
  assume_role_policy = data.aws_iam_policy_document.pipe_assume_policy_document.json
}

resource "aws_iam_role_policy" "pipe_sqs_role_policy" {
  policy = data.aws_iam_policy_document.pipe_sqs_policy_document.json
  role   = aws_iam_role.pipe_sqs_iam_role.id
}

resource "aws_iam_role" "pipe_dynamodb_iam_role" {
  name = "pipe-dynamodb-role"
  assume_role_policy = data.aws_iam_policy_document.pipe_assume_policy_document.json
}

resource "aws_iam_role_policy" "pipe_dynamodb_role_policy" {
  policy = data.aws_iam_policy_document.pipe_dynamodb_policy_document.json
  role   = aws_iam_role.pipe_dynamodb_iam_role.id
}


resource "aws_sqs_queue" "sqs" {}
