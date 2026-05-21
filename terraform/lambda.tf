# ── Zip the Lambda source automatically ───────────────────────────────────────
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/../lambda"
  output_path = "${path.module}/../lambda/function.zip"
  excludes    = ["function.zip"]
}

# ── Lambda Layer (built by GitHub Actions, uploaded to S3 or passed as file) ──
# The layer.zip is created by GitHub Actions and stored locally before tf apply.
resource "aws_lambda_layer_version" "shared_layer" {
  filename            = "${path.module}/../layer/layer.zip"
  layer_name = "shared-python-layer-${random_id.suffix.hex}"
  compatible_runtimes = ["python3.11"]
  source_code_hash    = filebase64sha256("${path.module}/../layer/layer.zip")

  lifecycle {
    create_before_destroy = true
  }
}

# ── Lambda function ────────────────────────────────────────────────────────────
resource "aws_lambda_function" "trigger_lambda" {

  function_name = "trigger-step-function-${random_id.suffix.hex}"
  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  role             = aws_iam_role.lambda_role.arn
  handler          = "app.lambda_handler"
  runtime          = "python3.11"
  timeout          = 30

  layers = [aws_lambda_layer_version.shared_layer.arn]

  environment {
    variables = {
      STATE_MACHINE_ARN = aws_sfn_state_machine.workflow.arn
    }
  }

  depends_on = [aws_lambda_layer_version.shared_layer]
}

