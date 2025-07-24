# Generate shared secret for JWT signing
resource "random_password" "webui_secret_key" {
  length  = 32
  special = false  # Avoid special characters that might cause issues
}

# Shared secret for consistent JWT tokens across instances
resource "aws_secretsmanager_secret" "webui_shared_secret" {
  name        = "webui-shared-secret"
  description = "Shared secret for WebUI JWT signing across instances"

  tags = {
    Name = "WebUI Shared Secret"
  }
}

resource "aws_secretsmanager_secret_version" "webui_shared_secret" {
  secret_id     = aws_secretsmanager_secret.webui_shared_secret.id
  secret_string = random_password.webui_secret_key.result
}

# Update IAM role policy to access new secrets
data "aws_iam_role" "task_execution_role" {
  name = "ecsTaskExecutionRole"
}

# IAM policy for accessing the new secrets
resource "aws_iam_policy" "secrets_access_policy" {
  name        = "webui-secrets-access-policy"
  description = "Policy for accessing WebUI secrets"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue"
        ]
        Resource = [
          aws_secretsmanager_secret.webui_shared_secret.arn,
          aws_secretsmanager_secret.redis_connection.arn,
          var.existing_database_secret_arn
        ]
      }
    ]
  })
}

# Attach policy to existing task execution role
resource "aws_iam_role_policy_attachment" "secrets_access_attachment" {
  role       = data.aws_iam_role.task_execution_role.name
  policy_arn = aws_iam_policy.secrets_access_policy.arn
} 