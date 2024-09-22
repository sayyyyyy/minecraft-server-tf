# Define variables for parameters
variable "instance_id" {
  description = "EC2 Instance ID to be stopped"
}

variable "schedule_stop_time" {
  default     = "cron(0 3 * * ? *)"
  description = "Time to stop the EC2 Instance"
}

variable "schedule_timezone" {
  default     = "Asia/Tokyo"
  description = "Schedule timezone"
}

# IAM Role for AWS Scheduler
resource "aws_iam_role" "scheduler_ec2_stop_role" {
  name = "minecraft-server-scheduler-stop-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "scheduler.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })

  inline_policy {
    name = "EC2StopPolicy"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [{
        Effect   = "Allow"
        Action   = ["ec2:StopInstances"]
        Resource = "*"
      }]
    })
  }

  path = "/"
}

# AWS Scheduler to stop EC2 instance
resource "aws_scheduler_schedule" "stop_minecraft_server_schedule" {
  name = "minecraft-server-stop-scheduler"

  schedule_expression           = var.schedule_stop_time
  schedule_expression_timezone  = var.schedule_timezone
  state                         = "ENABLED"
  flexible_time_window {
    mode = "OFF"
  }

  target {
    arn    = "arn:aws:scheduler:::aws-sdk:ec2:stopInstances"
    role_arn = aws_iam_role.scheduler_ec2_stop_role.arn

    input = jsonencode({
      InstanceIds = [var.instance_id]
    })
  }
}
