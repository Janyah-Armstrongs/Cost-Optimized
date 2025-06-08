output "ec2_instance_id" {
  value = aws_instance.test_instance.id
}

output "budget_name" {
  value = aws_budgets_budget.monthly_budget.name
}

output "lambda_function_name" {
  value = aws_lambda_function.stop_test_instances.function_name
}
