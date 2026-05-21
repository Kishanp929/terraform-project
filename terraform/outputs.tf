output "lambda_function_name" {
  value = aws_lambda_function.trigger_lambda.function_name
}

output "state_machine_arn" {
  value = aws_sfn_state_machine.workflow.arn
}

output "layer_arn" {
  value = aws_lambda_layer_version.shared_layer.arn
}