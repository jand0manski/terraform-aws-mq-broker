
resource "aws_cloudwatch_metric_alarm" "mq_broker_disk_space" {
  count = var.create_alarm ? 1:0
  alarm_name                = "${var.name}-HighDiskUsed-RabbitBroker"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "3"
  metric_name               = "StorePercentUsage"
  namespace                 = "AWS/AmazonMQ"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = var.disk_threshold
  alarm_description         = "This metric monitors high disk used"
  insufficient_data_actions = []
  actions_enabled = true
  alarm_actions = [var.sns_topic_arn]
  dimensions = {
    "Broker"    = var.name
  }
}


resource "aws_cloudwatch_metric_alarm" "mq_broker_memory" {
  count = var.create_alarm ? 1:0
  alarm_name                = "${var.name}-HighMemoryUsed-RabbitBroker"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "3"
  threshold                 = var.memory_threshold

  alarm_description         = "HighMemoryUsed-Broker"
  insufficient_data_actions = []
  actions_enabled = true
  alarm_actions = [var.sns_topic_arn]


  metric_query {
    id          = "e1"
    expression  = "m1/m2*100"
    label       = "MemoryUsed"
    return_data = "true"
	period      = 120
  }


  metric_query {
    id          = "m1"
    metric {
      metric_name = "RabbitMQMemUsed"
      namespace   = "AWS/AmazonMQ"
      period      = 120
      stat        = "Average"
      dimensions = {
        "Broker"    = var.name
      }
    }
  }

  metric_query {
    id          = "m2"
    metric {
      metric_name = "RabbitMQMemLimit"
      namespace   = "AWS/AmazonMQ"
      period      = 120
      stat        = "Average"
      dimensions = {
        "Broker"    = var.name
      }
    }
  }

  }

resource "aws_cloudwatch_metric_alarm" "mq_broker_cpu" {
  count = var.create_alarm ? 1:0
  alarm_name                = "${var.name}-HighCpuUsed-RabbitBroker"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "3"
  metric_name               = "SystemCpuUtilization"
  namespace                 = "AWS/AmazonMQ"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = var.cpu_threshold
  alarm_description         = "HighCpu-Used-Broker"
  insufficient_data_actions = []
  actions_enabled = true
  alarm_actions = [var.sns_topic_arn]
  dimensions = {
	 "Broker"    = var.name
  }
}
