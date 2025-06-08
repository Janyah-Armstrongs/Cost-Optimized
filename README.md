# Cost-Optimized Dev/Test Environment

## Overview
This Terraform project provisions a cost-efficient AWS environment for development and testing. It automates the creation and management of EC2 instances, budget monitoring, and optional automatic stopping of dev instances after hours to save money.

---

## What This Project Does

- **Creates EC2 instances** tagged with the environment (e.g., dev).
- **Sets up AWS Budgets** to monitor monthly spending on dev/test resources.
- **Sends email alerts** if spending exceeds 80% of the budget.
- **(Optional)** Deploys a Lambda function that stops dev EC2 instances every day at 7 PM to reduce costs.
- **Enforces resource tagging** for easier cost tracking and management.

---

## How to Use

1. **Clone this repository:**

```bash
git clone https://github.com/yourusername/your-repo.git
cd your-repo
Edit variables if needed:

Open variables.tf to customize AMI ID, instance type, budget limit, email for alerts, and region.

Prepare the Lambda deployment package:

Make sure your lambda_function.py (provided in the repo) is zipped as lambda_function.zip.

bash
Copy
Edit
zip lambda_function.zip lambda_function.py
Initialize Terraform:

bash
Copy
Edit
terraform init
Preview the changes Terraform will make:

bash
Copy
Edit
terraform plan
Apply the Terraform plan:

bash
Copy
Edit
terraform apply
Confirm the apply when prompted.

 ## How It Works
EC2 instance is launched with tags for environment tracking.

AWS Budget tracks the cost of resources tagged with the environment.

If spending exceeds 80% of the budget, an email notification is sent.

A Lambda function is scheduled daily to stop all running dev EC2 instances automatically.

IAM roles and permissions allow Lambda to safely manage EC2 instances and log actions.

Customization
Change variables in variables.tf to fit your environment.

Update the Lambda code to modify stopping behavior or extend functionality.

Adjust the CloudWatch event schedule in main.tf to change when instances stop.

Modify the budget amount or alert threshold as needed.

Update the notification email to your preferred contact.

Notes
The default AMI ID is for us-east-1. Update it if using a different region.

Remember to keep .terraform.lock.hcl local and exclude it from your repo with .gitignore.

