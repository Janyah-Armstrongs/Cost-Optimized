# Cost-Optimized Dev/Test Environment

## Overview
This Terraform project provisions a cost-efficient AWS environment for development and testing. It automates the creation and management of EC2 instances, budget monitoring, and optional automatic stopping of test instances after hours to save money.

---

## What This Project Does

- **Creates EC2 instances** tagged with the environment (e.g., dev).  
- **Sets up AWS Budgets** to monitor monthly spending on dev/test resources.  
- **Sends email alerts** if spending exceeds 80% of the budget.  
- **(Optional)** Deploys a Lambda function that stops dev EC2 instances every day at 7 PM to reduce costs.  
- **Enforces resource tagging** for easier cost tracking and management.

---

## Setup Steps

1. **Clone this repository:**

   ```bash
   git clone https://github.com/yourusername/your-repo.git
   cd your-repo
   ```

2. **Edit variables if needed:**  
   Open `variables.tf` and change the following based on your environment:
   - `region`: AWS region to deploy resources (default: `us-east-1`)
   - `env`: Environment tag (e.g., `dev`, `test`, `prod`)
   - `ami`: AMI ID to launch EC2 instances
   - `instance_type`: Type of EC2 instance (e.g., `t2.micro`)
   - `budget_limit`: Monthly budget limit (e.g., `"10.00"`)
   - `notification_email`: Email to receive AWS budget alerts

3. **Prepare the Lambda deployment package:**  
   Ensure your Lambda function code is in `lambda_function.py`, then zip it:

   ```bash
   zip lambda_function.zip lambda_function.py
   ```

4. **Initialize Terraform:**  
   Run the following to initialize the working directory and download required providers:

   ```bash
   terraform init
   ```

5. **Preview infrastructure changes:**  
   Check what Terraform will create/modify before applying:

   ```bash
   terraform plan
   ```

6. **Apply the Terraform configuration:**  
   Create the infrastructure. Type `yes` when prompted:

   ```bash
   terraform apply
   ```

---

## How It Works

- An EC2 instance is launched with the appropriate environment tag (e.g., `Env=dev`).
- AWS Budgets tracks the costs of all resources with that tag.
- If spending exceeds 80% of the budget, AWS sends an email to the provided contact.
- A Lambda function (if configured) stops running EC2 instances tagged `Env=dev` every day at 7 PM UTC.
- IAM roles and permissions allow Lambda to manage EC2 and log its actions.
- CloudWatch Events trigger the Lambda automatically.

---

## Customization

You can easily modify the project to suit your needs:

- **Region & AMI**: Change the `region` and `ami` variables in `variables.tf` for your AWS setup.
- **Budget Threshold**: Adjust `budget_limit` or the 80% alert threshold in `main.tf`.
- **Schedule**: Change the `cron` expression in the `aws_cloudwatch_event_rule` to run at a different time.
- **Email Alerts**: Update `notification_email` to your preferred contact.
- **Instance Type**: Choose a different EC2 instance type like `t3.micro` or `t2.small`.
- **Lambda Logic**: Edit the Python code in `lambda_function.py` to stop based on different tags, states, or schedules.

---

## Notes

- The default AMI ID is for the `us-east-1` region. If you use another region, replace it with a valid AMI ID for that region.
- Use a `.gitignore` file to prevent committing sensitive or unnecessary files like `.terraform/`, `.terraform.lock.hcl`, and `lambda_function.zip`.

Example `.gitignore`:
```
.terraform/
*.zip
*.tfstate
*.tfstate.*
.terraform.lock.hcl
```

---

Enjoy a cost-effective, automated environment setup with Terraform and AWS!
