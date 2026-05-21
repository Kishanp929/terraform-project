resource "aws_sfn_state_machine" "workflow" {
  name     = "demo-workflow"
  role_arn = aws_iam_role.step_function_role.arn

  definition = file("${path.module}/../step_function/definition.json")

  type = "STANDARD"
}