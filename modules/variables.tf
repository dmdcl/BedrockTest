# General Configuration
variable "project_name" {
  description = "Project name used for naming resources"
  type        = string
  default     = "bedrock-agent"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
}

# Bedrock Agent Configuration
variable "agent_name" {
  description = "Name of the Bedrock Agent"
  type        = string
  default     = "my-bedrock-agent"
}

variable "agent_alias_name" {
  description = "Name of the Bedrock Agent"
  type = string
  default = "production"
}

variable "agent_model_id" {
  description = "Model ID for the Bedrock Agent"
  type        = string
  default     = "anthropic.claude-sonnet-4-20250514"
}

variable "agent_instruction" {
  description = "Instructions for the Bedrock Agent"
  type        = string
  default     = "You are a helpful AI assistant with access to a knowledge base. Use the knowledge base to answer questions accurately."
}

variable "agent_description" {
  description = "Description of the Bedrock Agent"
  type        = string
  default     = "AI Agent with knowledge base integration"
}

variable "idle_session_ttl_in_seconds" {
  description = "How long the agent session remains active without user input"
  type        = number
  default     = 600
}

# Knowledge Base Configuration
variable "kb_name" {
  description = "Name of the Knowledge Base"
  type        = string
  default     = "agent-knowledge-base"
}

variable "kb_description" {
  description = "Description of the Knowledge Base"
  type        = string
  default     = "Knowledge base for Bedrock Agent"
}

variable "kb_embedding_model_id" {
  description = "Embedding model for the Knowledge Base"
  type        = string
  default     = "amazon.titan-embed-text-v2:0"
}

variable "vector_dimension" {
  description = "Dimension of vectors (1024 for Titan v2, 1536 for Titan v1)"
  type        = number
  default     = 1024
}

# OpenSearch Configuration
variable "opensearch_collection_name" {
  description = "Name of the OpenSearch Serverless collection"
  type        = string
  default     = "kb-vectors"
}

variable "opensearch_index_name" {
  description = "Name of the OpenSearch index"
  type        = string
  default     = "bedrock-kb-index"
}

# Chunking Strategy Configuration
variable "chunking_strategy" {
  description = "Chunking strategy (DEFAULT, FIXED_SIZE, HIERARCHICAL, SEMANTIC, NONE)"
  type        = string
  default     = "FIXED_SIZE"
  
  validation {
    condition     = contains(["DEFAULT", "FIXED_SIZE", "HIERARCHICAL", "SEMANTIC", "NONE"], var.chunking_strategy)
    error_message = "Must be one of: DEFAULT, FIXED_SIZE, HIERARCHICAL, SEMANTIC, NONE"
  }
}

variable "fixed_size_max_tokens" {
  description = "Max tokens for fixed-size chunks"
  type        = number
  default     = 512
}

variable "fixed_size_overlap_percentage" {
  description = "Overlap percentage between chunks"
  type        = number
  default     = 20
}

variable "hierarchical_overlap_tokens" {
  description = "Overlap tokens for hierarchical chunking"
  type        = number
  default     = 70
}

variable "hierarchical_parent_max_tokens" {
  description = "Max tokens for parent chunks"
  type        = number
  default     = 1000
}

variable "hierarchical_child_max_tokens" {
  description = "Max tokens for child chunks"
  type        = number
  default     = 500
}

variable "semantic_max_tokens" {
  description = "Max tokens for semantic chunks"
  type        = number
  default     = 512
}

variable "semantic_buffer_size" {
  description = "Buffer size for semantic chunking"
  type        = number
  default     = 1
}

variable "semantic_breakpoint_percentile_threshold" {
  description = "Breakpoint percentile threshold for semantic chunking"
  type        = number
  default     = 75
}

# Tags
variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}