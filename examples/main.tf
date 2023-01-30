module "pipe_dynamodb" {
  source = "../"

  name = "test-pipe"
  source_type = "dynamodb"
  source_arn = "arn:aws:dynamodb:us-east-1:793209430381:table/aft-request/stream/2023-01-06T06:44:56.016"
  target_arn = "arn:aws:lambda:us-east-1:793209430381:function:aft-process"
  role_arn = aws_iam_role.pipe_iam_role.arn

  dynamo_db_stream_parameters = {
    starting_position = "LATEST"
  }
}

output "d" {
  value = module.pipe_dynamodb.sourcemap
}

resource "aws_iam_role" "pipe_iam_role" {
  name = "dynamodb-pipe-role"
  assume_role_policy = data.aws_iam_policy_document.pipe_assume_policy_document.json
}

resource "aws_iam_role_policy" "pipe_dynamodb_role_policy" {
  policy = data.aws_iam_policy_document.pipe_dynamodb_policy_document.json
  role   = aws_iam_role.pipe_iam_role.id
}
