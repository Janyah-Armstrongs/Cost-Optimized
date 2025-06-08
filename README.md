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

## How to Use

1. **Clone this repository:**

```bash
git clone https://github.com/yourusername/your-repo.git
cd your-repo

2. **Edit variables if needed:**  
   Open `variables.tf` to customize AMI ID, instance type, budget limit, email for alerts, and region.

3. **Prepare the Lambda deployment package:**  
   Make sure your `lambda_function.py` (provided in the repo) is zipped as `lambda_function.zip`.  
   ```bash
   zip lambda_function.zip lambda_function.py

## How It Works

- An EC2 instance is launched with tags for environment tracking.
- AWS Budget tracks the cost of resources tagged with the environment.
- If spending exceeds 80% of the budget, an email notification is sent.
- A Lambda function is scheduled daily to stop all running dev EC2 instances automatically.
- IAM roles and permissions allow Lambda to safely manage EC2 instances and log actions.
