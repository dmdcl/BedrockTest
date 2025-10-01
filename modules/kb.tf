# Bedrock Knowledge Base
resource "aws_bedrockagent_knowledge_base" "main" {
  name     = "${local.name_prefix}-${var.kb_name}"
  role_arn = aws_iam_role.kb.arn
  
  description = var.kb_description
  
  knowledge_base_configuration {
    type = "VECTOR"
    vector_knowledge_base_configuration {
      embedding_model_arn = local.kb_model_arn
    }
  }
  
  storage_configuration {
    type = "OPENSEARCH_SERVERLESS"
    opensearch_serverless_configuration {
      collection_arn    = aws_opensearchserverless_collection.main.arn
      vector_index_name = var.opensearch_index_name
      
      field_mapping {
        vector_field   = "bedrock-knowledge-base-default-vector"
        text_field     = "AMAZON_BEDROCK_TEXT_CHUNK"
        metadata_field = "AMAZON_BEDROCK_METADATA"
      }
    }
  }
  
  tags = local.common_tags
  
  depends_on = [
    aws_iam_role_policy.kb_model,
    aws_iam_role_policy.kb_s3,
    opensearch_index.main,
    time_sleep.iam_propagation
  ]
}

# Knowledge Base Data Source
resource "aws_bedrockagent_data_source" "main" {
  knowledge_base_id = aws_bedrockagent_knowledge_base.main.id
  name              = "${local.name_prefix}-${var.kb_name}-datasource"
  
  data_source_configuration {
    type = "S3"
    s3_configuration {
      bucket_arn = aws_s3_bucket.kb.arn
    }
  }
  
  # Chunking configuration
  dynamic "vector_ingestion_configuration" {
    for_each = var.chunking_strategy != "DEFAULT" ? [1] : []
    
    content {
      chunking_configuration {
        chunking_strategy = var.chunking_strategy
        
        # Fixed Size Chunking
        dynamic "fixed_size_chunking_configuration" {
          for_each = var.chunking_strategy == "FIXED_SIZE" ? [1] : []
          content {
            max_tokens         = var.fixed_size_max_tokens
            overlap_percentage = var.fixed_size_overlap_percentage
          }
        }
        
        # Hierarchical Chunking
        dynamic "hierarchical_chunking_configuration" {
          for_each = var.chunking_strategy == "HIERARCHICAL" ? [1] : []
          content {
            overlap_tokens = var.hierarchical_overlap_tokens
            level_configuration {
              max_tokens = var.hierarchical_parent_max_tokens
            }
            level_configuration {
              max_tokens = var.hierarchical_child_max_tokens
            }
          }
        }
        
        # Semantic Chunking
        dynamic "semantic_chunking_configuration" {
          for_each = var.chunking_strategy == "SEMANTIC" ? [1] : []
          content {
            max_token                       = var.semantic_max_tokens
            buffer_size                     = var.semantic_buffer_size
            breakpoint_percentile_threshold = var.semantic_breakpoint_percentile_threshold
          }
        }
      }
    }
  }
}