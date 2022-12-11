provider "aws" {
  access_key = "AKIARBJQQX47RRPH5MMX"
  secret_key = "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"
  region = var.availability_zone_names
}

resource "aws_iam_role" "udacity_lambda_role_terraform" {
name   = "Udacity-LambdaSQSQueueExcutionRole-Terraform"
assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "sts:AssumeRole"
            ],
            "Principal": {
                "Service": [
                    "lambda.amazonaws.com"
                ]
            }
        }
    ]
}
EOF
}

resource "aws_iam_policy" "udacity_lambda_iam_policy_terraform" {
 
 name         = "Udacity-LambdaRolePolicy-Terraform"
 path         = "/"
 description  = "Udacity AWS IAM Policy for managing Udacity AWS lambda role"
 policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "sqs:DeleteMessage",
                "logs:CreateLogStream",
                "sqs:ReceiveMessage",
                "sqs:GetQueueAttributes",
                "logs:CreateLogGroup",
                "logs:PutLogEvents"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "udacity_policy_role_attach_terraform" {
 role        = aws_iam_role.udacity_lambda_role_terraform.name
 policy_arn  = aws_iam_policy.udacity_lambda_iam_policy_terraform.arn
}

data "archive_file" "python_code_zip" {
type        = "zip"
source_dir  = "${path.module}/python/"
output_path = "${path.module}/python/hello-python.zip"
}

resource "aws_sqs_queue" "udacity_queue_terraform" {
  name      = "Udacity-SQSQueue-Terraform"
}

resource "aws_lambda_function" "udacity_lambda_func_terraform" {
filename                       = "${path.module}/python/hello-python.zip"
function_name                  = "Udacity-LambdaSQSQueueExcution-Terraform"
role                           = aws_iam_role.udacity_lambda_role_terraform.arn
handler                        = "greet_lambda.lambda_handler"
runtime                        = "python3.9"
depends_on                     = [aws_iam_role_policy_attachment.udacity_policy_role_attach_terraform]
}

resource "aws_lambda_event_source_mapping" "udacity_event_source_mapping_terraform" {
  batch_size        = 1
  event_source_arn  = aws_sqs_queue.udacity_queue_terraform.arn
  enabled           = true
  function_name     = aws_lambda_function.udacity_lambda_func_terraform.arn
}

