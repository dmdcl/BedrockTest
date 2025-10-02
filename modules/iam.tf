# Bedrock Agent IAM Role
resource "aws_iam_role" "agent" {
  name = "${local.name_prefix}-agent-role"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "bedrock.amazonaws.com"
      }
      Condition = {
        StringEquals = {
          "aws:SourceAccount" = local.account_id
        }
        ArnLike = {
          "aws:SourceArn" = "arn:${local.partition}:bedrock:${local.region}:${local.account_id}:agent/*"
        }
      }
    }]
  })
  
  tags = local.common_tags
}

resource "aws_iam_role_policy" "agent_model" {
  name = "${local.name_prefix}-agent-model-policy"
  role = aws_iam_role.agent.id
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "bedrock:InvokeModel",
        "bedrock:InvokeModelWithResponseStream",
        "bedrock:GetInferenceProfile",
        "bedrock:GetFoundationModel"
      ]
      Resource = [
        local.agent_inference_profile_arn,
        local.agent_foundation_model_arn
          
      ]
    }]
  })
}

resource "aws_iam_role_policy" "agent_kb" {
  name = "${local.name_prefix}-agent-kb-policy"
  role = aws_iam_role.agent.id
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "bedrock:Retrieve"
      ]
      Resource = aws_bedrockagent_knowledge_base.main.arn
    }]
  })
}

# Knowledge Base IAM Role
resource "aws_iam_role" "kb" {
  name = "${local.name_prefix}-kb-role"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "bedrock.amazonaws.com"
      }
      Condition = {
        StringEquals = {
          "aws:SourceAccount" = local.account_id
        }
        ArnLike = {
          "aws:SourceArn" = "arn:${local.partition}:bedrock:${local.region}:${local.account_id}:knowledge-base/*"
        }
      }
    }]
  })
  
  tags = local.common_tags
}

resource "aws_iam_role_policy" "kb_model" {
  name = "${local.name_prefix}-kb-model-policy"
  role = aws_iam_role.kb.id
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = "bedrock:InvokeModel"
      Resource = local.kb_model_arn
    }]
  })
}

resource "aws_iam_role_policy" "kb_s3" {
  name = "${local.name_prefix}-kb-s3-policy"
  role = aws_iam_role.kb.id
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "s3:ListBucket"
        Resource = aws_s3_bucket.kb.arn
        Condition = {
          StringEquals = {
            "aws:ResourceAccount" = local.account_id
          }
        }
      },
      {
        Effect   = "Allow"
        Action   = "s3:GetObject"
        Resource = "${aws_s3_bucket.kb.arn}/*"
        Condition = {
          StringEquals = {
            "aws:ResourceAccount" = local.account_id
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "kb_opensearch" {
  name = "${local.name_prefix}-kb-opensearch-policy"
  role = aws_iam_role.kb.id
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = "aoss:APIAccessAll"
      Resource = aws_opensearchserverless_collection.main.arn
    }]
  })
}

# Wait for IAM policies to propagate
resource "time_sleep" "iam_propagation" {
  create_duration = "60s"
  
  depends_on = [
    aws_iam_role_policy.kb_model,
    aws_iam_role_policy.kb_s3,
    aws_iam_role_policy.kb_opensearch
  ]
}