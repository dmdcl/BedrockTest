terraform {
  required_version = ">= 1.5.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.48"
    }
    opensearch = {
      source  = "opensearch-project/opensearch"
      version = "= 2.2.0"
    }
    time = {
      source  = "hashicorp/time"
      version = "~> 0.9"
    }
  }
}

# Data Sources
data "aws_caller_identity" "current" {}
data "aws_partition" "current" {}
data "aws_region" "current" {}

# Local Variables
locals {
  account_id = data.aws_caller_identity.current.account_id
  partition  = data.aws_partition.current.partition
  region     = data.aws_region.current.name
  
  # Naming conventions
  name_prefix = "${var.project_name}-${var.environment}"
  
 # Model ARNs (inference profile + foundation model)
  agent_inference_profile_id  = "us.${var.agent_model_id}"
  agent_inference_profile_arn = "arn:${local.partition}:bedrock:${local.region}:${local.account_id}:inference-profile/${local.agent_inference_profile_id}"
  agent_foundation_model_arn  = "arn:${local.partition}:bedrock:*::foundation-model/${var.agent_model_id}"

    # KB model ARN
  kb_model_arn = "arn:${local.partition}:bedrock:${local.region}::foundation-model/${var.kb_embedding_model_id}"
  
  
  # Common tags
  common_tags = merge(
    var.tags,
    {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "Terraform"
    }
  )
}