# ── Lambda execution role ──────────────────────────────────────────────────────
resource "aws_iam_role" "lambda_role" {
  name = "lambda-step-trigger-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "lambda.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_policy" "lambda_sfn_policy" {
  name = "lambda-start-sfn-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = ["states:StartExecution"]
      Resource = aws_sfn_state_machine.workflow.arn
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_sfn_attach" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_sfn_policy.arn
}

# ── Step Function execution role ───────────────────────────────────────────────
resource "aws_iam_role" "step_function_role" {
  name = "step-function-exec-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "states.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

# CloudWatch Logs permission for Step Functions
resource "aws_iam_role_policy" "sfn_logs" {
  name = "sfn-logs-policy"
  role = aws_iam_role.step_function_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "logs:CreateLogGroup",
        "logs:CreateLogDelivery",
        "logs:PutLogEvents",
        "logs:GetLogDelivery"
      ]
      Resource = "*"
    }]
  })
}