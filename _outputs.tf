output "rule_name" {
  description = "The name of the EventBridge rule"
  value       = aws_cloudwatch_event_rule.this.name
}

output "rule_arn" {
  description = "The ARN of the EventBridge rule"
  value       = aws_cloudwatch_event_rule.this.arn
}

output "target_id" {
  description = "The ID of the EventBridge target"
  value       = aws_cloudwatch_event_target.this.target_id
}

output "dlq_queue_arn" {
  description = "The ARN of the dead letter queue (if created)"
  value       = var.enable_dlq ? module.dlq[0].arn : null
}

output "dlq_queue_url" {
  description = "The URL of the dead letter queue (if created)"
  value       = var.enable_dlq ? module.dlq[0].url : null
}