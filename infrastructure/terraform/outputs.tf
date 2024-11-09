# infrastructure/terraform/outputs.tf

output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_id" {
  description = "The ID of the public subnet"
  value       = aws_subnet.public.id
}

output "private_subnet_id" {
  description = "The ID of the private subnet"
  value       = aws_subnet.private.id
}

output "web_instance_id" {
  description = "The ID of the EC2 instance"
  value       = aws_instance.web.id
}

output "web_instance_public_ip" {
  description = "The public IP of the EC2 instance"
  value       = aws_instance.web.public_ip
}

output "web_instance_private_ip" {
  description = "The private IP of the EC2 instance"
  value       = aws_instance.web.private_ip
}

output "app_load_balancer_dns" {
  description = "The DNS name of the Application Load Balancer"
  value       = aws_lb.app_lb.dns_name
}

output "app_load_balancer_arn" {
  description = "The ARN of the Application Load Balancer"
  value       = aws_lb.app_lb.arn
}

output "auto_scaling_group_id" {
  description = "The ID of the Auto Scaling Group"
  value       = aws_autoscaling_group.web_asg.id
}

output "log_bucket_name" {
  description = "The name of the S3 bucket for logs"
  value       = aws_s3_bucket.log_bucket.bucket
}

output "cloudwatch_alarm_high_cpu" {
  description = "The name of the CloudWatch alarm for high CPU utilization"
  value       = aws_cloudwatch_metric_alarm.high_cpu.alarm_name
}
