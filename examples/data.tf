data "aws_iam_policy_document" "pipe_assume_policy_document" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["pipes.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "pipe_dynamodb_policy_document" {
  statement {
    sid = "InvokeLambda"
    actions = [
      "lambda:InvokeFunction"
    ]
    resources = ["*"]
  }
  statement {
    sid = "AccessDynamoDB"
    actions = [
      "dynamodb:DescribeStream",
      "dynamodb:GetRecords",
      "dynamodb:GetShardIterator",
      "dynamodb:ListStreams",
    ]
    resources = ["*"]
  }
}
