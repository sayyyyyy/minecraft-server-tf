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
