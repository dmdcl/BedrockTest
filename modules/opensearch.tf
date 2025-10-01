# OpenSearch Serverless Security Policies
resource "aws_opensearchserverless_security_policy" "encryption" {
  name = "${local.name_prefix}-kb-enc"
  type = "encryption"
  
  policy = jsonencode({
    Rules = [{
      Resource     = ["collection/${local.name_prefix}-kb-col"]
      ResourceType = "collection"
    }]
    AWSOwnedKey = true
  })
}

resource "aws_opensearchserverless_security_policy" "network" {
  name = "${local.name_prefix}-kb-net"
  type = "network"
  
  policy = jsonencode([{
    Rules = [
      {
        ResourceType = "collection"
        Resource     = ["collection/${local.name_prefix}-kb-col"]
      },
      {
        ResourceType = "dashboard"
        Resource     = ["collection/${local.name_prefix}-kb-col"]
      }
    ]
    AllowFromPublic = true
  }])
}

resource "aws_opensearchserverless_access_policy" "main" {
  name = "${local.name_prefix}-kb-acc"
  type = "data"
  
  policy = jsonencode([{
    Rules = [
      {
        ResourceType = "index"
        Resource     = ["index/${local.name_prefix}-kb-col/*"]
        Permission = [
          "aoss:CreateIndex",
          "aoss:DeleteIndex",
          "aoss:DescribeIndex",
          "aoss:ReadDocument",
          "aoss:UpdateIndex",
          "aoss:WriteDocument"
        ]
      },
      {
        ResourceType = "collection"
        Resource     = ["collection/${local.name_prefix}-kb-col"]
        Permission = [
          "aoss:CreateCollectionItems",
          "aoss:DescribeCollectionItems",
          "aoss:UpdateCollectionItems"
        ]
      }
    ]
    Principal = [
      aws_iam_role.kb.arn,
      data.aws_caller_identity.current.arn
    ]
  }])
}

# OpenSearch Serverless Collection
resource "aws_opensearchserverless_collection" "main" {
  name = "${local.name_prefix}-kb-col"
  type = "VECTORSEARCH"
  
  tags = local.common_tags
  
  depends_on = [
    aws_opensearchserverless_access_policy.main,
    aws_opensearchserverless_security_policy.encryption,
    aws_opensearchserverless_security_policy.network
  ]
}


# OpenSearch Provider Configuration
provider "opensearch" {
  url         = aws_opensearchserverless_collection.main.collection_endpoint
  healthcheck = false
}

# OpenSearch Index
resource "opensearch_index" "main" {
  name               = var.opensearch_index_name
  number_of_shards   = "2"
  number_of_replicas = "0"
  
  index_knn                      = true
  index_knn_algo_param_ef_search = "512"
  
  mappings = jsonencode({
    properties = {
      "bedrock-knowledge-base-default-vector" = {
        type      = "knn_vector"
        dimension = var.vector_dimension
        method = {
          name   = "hnsw"
          engine = "faiss"
          parameters = {
            m              = 16
            ef_construction = 512
          }
          space_type = "l2"
        }
      }
      "AMAZON_BEDROCK_METADATA" = {
        type  = "text"
        index = "false"
      }
      "AMAZON_BEDROCK_TEXT_CHUNK" = {
        type  = "text"
        index = "true"
      }
    }
  })
  
  force_destroy = true
  
  depends_on = [
    aws_opensearchserverless_access_policy.main,
    aws_opensearchserverless_collection.main,
    time_sleep.opensearch_policy_propagation
  ]
}

resource "time_sleep" "opensearch_policy_propagation" {
  create_duration = "60s"
}