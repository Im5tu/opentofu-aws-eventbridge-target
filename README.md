# OpenTofu AWS EventBridge Target

This module creates an Amazon EventBridge rule and target, enabling event-driven architectures by routing events to downstream AWS services. It optionally provisions a dead letter queue (SQS) for capturing failed event deliveries, with configurable retry policies (60 second maximum age, 3 retry attempts) for all targets except EventBridge-to-EventBridge integrations.

## Usage

```hcl
module "eventbridge_target" {
  source = "git::https://github.com/im5tu/opentofu-aws-eventbridge-target.git?ref=b2016e4f000c318e5c730af9a9d2b90d03a23f5d"

  name               = "order-processor"
  event_bus_name     = "orders"
  invocation_target_arn = aws_lambda_function.order_processor.arn
  invocation_role_arn   = aws_iam_role.eventbridge_invoke.arn
  description        = "Routes order events to the order processor Lambda"

  event_pattern = jsonencode({
    source      = ["com.myapp.orders"]
    detail-type = ["OrderCreated", "OrderUpdated"]
  })

  enable_dlq  = true
  kms_key_arn = aws_kms_key.sqs.arn

  tags = {
    Environment = "production"
    Team        = "platform"
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| opentofu | >= 1.9 |
| aws | ~> 6 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | The name of the rule | `string` | - | yes |
| event_bus_name | The name of the eventbridge instance to configure against | `string` | - | yes |
| invocation_target_arn | The ARN of the target for the rule | `string` | - | yes |
| event_pattern | The pattern to use for matching events to the target | `string` | `null` | no |
| invocation_role_arn | The role to use for all parts of the invocation | `string` | `null` | no |
| description | The description of the rule | `string` | `""` | no |
| enable_dlq | Whether to create a dead letter queue for failed events | `bool` | `true` | no |
| kms_key_arn | The ARN of the KMS key used to secure the DLQ (if enabled) | `string` | `null` | no |
| tags | Tags that are specific to this module | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| rule_name | The name of the EventBridge rule |
| rule_arn | The ARN of the EventBridge rule |
| target_id | The ID of the EventBridge target |
| dlq_queue_arn | The ARN of the dead letter queue (if created) |
| dlq_queue_url | The URL of the dead letter queue (if created) |

## Development

### Validation

This module uses GitHub Actions for validation:

- **Format check**: `tofu fmt -check -recursive`
- **Validation**: `tofu validate`
- **Security scanning**: Checkov, Trivy

### Local Development

```bash
# Format code
tofu fmt -recursive

# Validate
tofu init -backend=false
tofu validate
```

## License

MIT License - see [LICENSE](LICENSE) for details.
