# Bedrock Agent Outputs
output "agent_id" {
  description = "ID of the Bedrock Agent"
  value       = aws_bedrockagent_agent.main.id
}

output "agent_arn" {
  description = "ARN of the Bedrock Agent"
  value       = aws_bedrockagent_agent.main.agent_arn
}

output "agent_name" {
  description = "Name of the Bedrock Agent"
  value       = aws_bedrockagent_agent.main.agent_name
}

# Knowledge Base Outputs
output "knowledge_base_id" {
  description = "ID of the Knowledge Base"
  value       = aws_bedrockagent_knowledge_base.main.id
}

output "knowledge_base_arn" {
  description = "ARN of the Knowledge Base"
  value       = aws_bedrockagent_knowledge_base.main.arn
}

output "data_source_id" {
  description = "ID of the Knowledge Base data source"
  value       = aws_bedrockagent_data_source.main.id
}

# OpenSearch Outputs
output "opensearch_collection_arn" {
  description = "ARN of the OpenSearch Serverless collection"
  value       = aws_opensearchserverless_collection.main.arn
}

output "opensearch_collection_endpoint" {
  description = "Endpoint of the OpenSearch Serverless collection"
  value       = aws_opensearchserverless_collection.main.collection_endpoint
}


# S3 Outputs
output "s3_bucket_name" {
  description = "Name of the S3 bucket used for knowledge base"
  value       = aws_s3_bucket.kb.bucket
}

output "s3_bucket_arn" {
  description = "ARN of the S3 bucket used for knowledge base"
  value       = aws_s3_bucket.kb.arn
}

# IAM Outputs
output "agent_role_arn" {
  description = "ARN of the Bedrock Agent IAM role"
  value       = aws_iam_role.agent.arn
}

output "kb_role_arn" {
  description = "ARN of the Knowledge Base IAM role"
  value       = aws_iam_role.kb.arn
}

# Region Info
output "region" {
  description = "AWS region"
  value       = data.aws_region.current.name
}

output "account_id" {
  description = "AWS account ID"
  value       = data.aws_caller_identity.current.account_id
}