resource "awscc_sqs_queue" "msdefender" {
  count = var.anti_virus_sqs ? 1 : 0
  queue_name                   = "${var.lab_name}-msdefender.fifo"
  fifo_queue                   = true
  content_based_deduplication  = true
  tags = [
    for k, v in merge(
      var.tags,
      { Name = "sqs-mdefender" }
    ) : {
      key   = k
      value = v
    }
  ]

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

resource "awscc_sqs_queue" "bitdefender" {
  count = var.anti_virus_sqs ? 1 : 0
  queue_name                   = "${var.lab_name}-bitdefender.fifo"
  fifo_queue                   = true
  content_based_deduplication  = true
  tags = [
    for k, v in merge(
      var.tags,
      { Name = "sqs-bitdefender" }
    ) : {
      key   = k
      value = v
    }
  ]

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

resource "awscc_sqs_queue" "eset" {
  count = var.anti_virus_sqs ? 1 : 0
  queue_name                   = "${var.lab_name}-eset.fifo"
  fifo_queue                   = true
  content_based_deduplication  = true
  tags = [
    for k, v in merge(
      var.tags,
      { Name = "sqs-eset" }
    ) : {
      key   = k
      value = v
    }
  ]

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}