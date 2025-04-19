# outputs.tf
output "ecr_s3_service_uri" {
  value = aws_ecr_repository.s3_service.repository_url
}

output "ecr_sqs_service_uri" {
  value = aws_ecr_repository.sqs_service.repository_url
}

output "ecs_cluster_name" {
  value = aws_ecs_cluster.this.name
}

output "s3_bucket_name" {
  value = aws_s3_bucket.this.bucket
}

output "sqs_queue_url" {
  value = aws_sqs_queue.this.id
}

output "ecs_task_execution_role_arn" {
  value = aws_iam_role.ecs_task_execution_role.arn
}
