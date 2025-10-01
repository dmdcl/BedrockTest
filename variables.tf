# AWS Configuration
variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

# General Configuration
variable "project_name" {
  description = "Project name used for naming resources"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
}

# Bedrock Agent Configuration
variable "agent_name" {
  description = "Name of the Bedrock Agent"
  type        = string
}

variable "agent_model_id" {
  description = "Model ID for the Bedrock Agent"
  type        = string
  default     = "anthropic.claude-sonnet-4-20250514"
}

variable "agent_instruction" {
  description = "Instructions for the Bedrock Agent"
  type        = string
}

variable "agent_description" {
  description = "Description of the Bedrock Agent"
  type        = string
}

# Knowledge Base Configuration
variable "kb_name" {
  description = "Name of the Knowledge Base"
  type        = string
}

variable "kb_description" {
  description = "Description of the Knowledge Base"
  type        = string
}

variable "kb_embedding_model_id" {
  description = "Embedding model for the Knowledge Base"
  type        = string
  default     = "amazon.titan-embed-text-v2:0"
}

# OpenSearch Configuration
variable "opensearch_collection_name" {
  description = "Name of the OpenSearch Serverless collection"
  type        = string
}

variable "opensearch_index_name" {
  description = "Name of the OpenSearch index"
  type        = string
}


# Chunking Strategy
variable "chunking_strategy" {
  description = "Chunking strategy (DEFAULT, FIXED_SIZE, HIERARCHICAL, SEMANTIC, NONE)"
  type        = string
}

variable "fixed_size_max_tokens" {
  description = "Max tokens for fixed-size chunks"
  type        = number
}

variable "fixed_size_overlap_percentage" {
  description = "Overlap percentage between chunks"
  type        = number
}

# Tags
variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
