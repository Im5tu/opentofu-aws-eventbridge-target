resource "aws_cloudwatch_event_rule" "this" {
  name           = var.name
  description    = var.description
  event_bus_name = var.event_bus_name
  role_arn       = var.invocation_role_arn
  event_pattern  = var.event_pattern

  tags = merge(var.tags, {
    Name = var.name
  })
}

resource "aws_cloudwatch_event_target" "this" {
  arn            = var.invocation_target_arn
  rule           = aws_cloudwatch_event_rule.this.name
  event_bus_name = var.event_bus_name
  role_arn       = var.invocation_role_arn

  dynamic "retry_policy" {
    # When doing an eventbridge to eventbridge integration, you cannot specify a retry policy
    for_each = length(regexall("^arn:aws:events", var.invocation_target_arn)) > 0 ? [] : [{ age = 60, attempts = 3 }]
    content {
      maximum_event_age_in_seconds = retry_policy.value["age"]
      maximum_retry_attempts       = retry_policy.value["attempts"]
    }
  }

  dynamic "dead_letter_config" {
    for_each = var.enable_dlq ? [1] : []
    content {
      arn = module.dlq[0].arn
    }
  }
}

module "dlq" {
  count  = var.enable_dlq ? 1 : 0
  source = "git::https://github.com/im5tu/opentofu-aws-sqs.git?ref=ce6739558c2324144583524879532e603c044dea"

  name        = "${var.name}-dlq"
  kms_key_arn = var.kms_key_arn
}
