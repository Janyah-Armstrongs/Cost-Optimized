provider "aws" {
  region = var.region
}

# EC2 instance with tags
resource "aws_instance" "test_instance" {
  ami           = var.ami
  instance_type = var.instance_type

  tags = {
    Name = "MyProject-Test"
    Env  = var.env
  }
}

# Budget for test environment cost monitoring
resource "aws_budgets_budget" "monthly_budget" {
  name         = "MyProject-TestBudget"
  budget_type  = "COST"
  limit_amount = var.budget_limit
  limit_unit   = "USD"
  time_unit    = "MONTHLY"

  cost_filter {
    name = "Service"
    values = [
      "Amazon Elastic Compute Cloud - Compute",
    ]
  }

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 80
    threshold_type             = "PERCENTAGE"
    notification_type          = "ACTUAL"
    subscriber_email_addresses = [var.notification_email]
  }
}

# IAM Role for Lambda to stop EC2 instances
resource "aws_iam_role" "lambda_ec2_stop_role" {
  name = "lambda_ec2_stop_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action    = "sts:AssumeRole",
      Principal = { Service = "lambda.amazonaws.com" },
      Effect    = "Allow",
      Sid       = "",
    }]
  })
}

resource "aws_iam_policy" "test_lambda_ec2_stop_policy" {
  name = "test_lambda_ec2_stop_policy"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ec2:DescribeInstances",
          "ec2:StopInstances"
        ],
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attach" {
  role       = aws_iam_role.lambda_ec2_stop_role.name
  policy_arn = aws_iam_policy.test_lambda_ec2_stop_policy.arn
}

# Lambda function to stop test EC2 instances
resource "aws_lambda_function" "stop_test_instances" {
  filename         = "lambda_function.zip"
  function_name    = "stop_test_instances"
  role             = aws_iam_role.lambda_ec2_stop_role.arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.9"
  source_code_hash = filebase64sha256("lambda_function.zip")
}

# CloudWatch Event Rule - triggers every day at 7 PM UTC
resource "aws_cloudwatch_event_rule" "daily_7pm" {
  name                = "stop-test-instances-daily-7pm"
  schedule_expression = "cron(0 19 * * ? *)"
}

# CloudWatch Event Target - invokes Lambda on schedule
resource "aws_cloudwatch_event_target" "invoke_lambda" {
  rule      = aws_cloudwatch_event_rule.daily_7pm.name
  target_id = "invoke_lambda"
  arn       = aws_lambda_function.stop_test_instances.arn
}

# Allow CloudWatch Events to invoke Lambda
resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.stop_test_instances.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.daily_7pm.arn
}
