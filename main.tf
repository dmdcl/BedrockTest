terraform {
  required_version = ">= 1.5.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.48"
    }
  }
}

provider "aws" {
  region = var.aws_region
  profile = var.aws_profile
}


# Bedrock Agent Module CallS
module "bedrock_agent" {
  source = "./modules"
  
  # General
  project_name = var.project_name
  environment  = var.environment
  
  # Agent
  agent_name        = var.agent_name
  agent_model_id    = var.agent_model_id
  agent_alias_name = var.agent_alias_name
  agent_instruction = var.agent_instruction
  agent_description = var.agent_description
  
  # Knowledge Base
  kb_name               = var.kb_name
  kb_description        = var.kb_description
  kb_embedding_model_id = var.kb_embedding_model_id
  
  # OpenSearch
  opensearch_collection_name = var.opensearch_collection_name
  opensearch_index_name      = var.opensearch_index_name
  
  # Chunking
  chunking_strategy             = var.chunking_strategy
  fixed_size_max_tokens         = var.fixed_size_max_tokens
  fixed_size_overlap_percentage = var.fixed_size_overlap_percentage
  
  # Tags
  tags = var.tags
}