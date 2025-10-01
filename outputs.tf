# Root Module Outputs
output "agent_id" {
  description = "ID of the Bedrock Agent"
  value       = module.bedrock_agent.agent_id
}

output "agent_arn" {
  description = "ARN of the Bedrock Agent"
  value       = module.bedrock_agent.agent_arn
}

output "agent_name" {
  description = "Name of the Bedrock Agent"
  value       = module.bedrock_agent.agent_name
}

output "knowledge_base_id" {
  description = "ID of the Knowledge Base"
  value       = module.bedrock_agent.knowledge_base_id
}

output "knowledge_base_arn" {
  description = "ARN of the Knowledge Base"
  value       = module.bedrock_agent.knowledge_base_arn
}

output "data_source_id" {
  description = "ID of the Knowledge Base data source"
  value       = module.bedrock_agent.data_source_id
}

output "opensearch_collection_arn" {
  description = "ARN of the OpenSearch Serverless collection"
  value       = module.bedrock_agent.opensearch_collection_arn
}

output "opensearch_endpoint" {
  description = "OpenSearch collection endpoint"
  value       = module.bedrock_agent.opensearch_collection_endpoint
}

output "s3_bucket_name" {
  description = "Name of the S3 bucket used for knowledge base"
  value       = module.bedrock_agent.s3_bucket_name
}

output "region" {
  description = "AWS region"
  value       = module.bedrock_agent.region
}

output "account_id" {
  description = "AWS account ID"
  value       = module.bedrock_agent.account_id
}

# Convenient Commands
output "sync_kb_command" {
  description = "Command to sync Knowledge Base from S3"
  value = <<-EOT
  aws bedrock-agent start-ingestion-job \
    --knowledge-base-id ${module.bedrock_agent.knowledge_base_id} \
    --data-source-id ${module.bedrock_agent.data_source_id} \
    --region ${module.bedrock_agent.region}
  EOT
}

output "test_agent_command" {
  description = "Command to test the agent"
  value = <<-EOT
  aws bedrock-agent-runtime invoke-agent \
    --agent-id ${module.bedrock_agent.agent_id} \
  
    --session-id test-session \
    --input-text "Hello, what can you help me with?" \
    --region ${module.bedrock_agent.region}
  EOT
}