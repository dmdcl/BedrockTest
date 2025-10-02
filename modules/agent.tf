# ==========================================
# Bedrock Agent
# ==========================================
resource "aws_bedrockagent_agent" "main" {
  agent_name              = "${local.name_prefix}-${var.agent_name}"
  agent_resource_role_arn = aws_iam_role.agent.arn
  foundation_model        = local.agent_inference_profile_id
  
  description = var.agent_description
  instruction = var.agent_instruction
  
  idle_session_ttl_in_seconds = var.idle_session_ttl_in_seconds
  
  tags = local.common_tags
  
  depends_on = [
    aws_iam_role_policy.agent_model,
    aws_iam_role_policy.agent_kb,
    aws_bedrockagent_knowledge_base.main,
    aws_s3_bucket.kb,
    time_sleep.iam_propagation
  ]
}

# ==========================================
# Agent Knowledge Base Association
# ==========================================
resource "aws_bedrockagent_agent_knowledge_base_association" "main" {
  agent_id             = aws_bedrockagent_agent.main.id
  knowledge_base_id    = aws_bedrockagent_knowledge_base.main.id
  knowledge_base_state = "ENABLED"
  description          = "Knowledge base for ${var.agent_name}"
  
  depends_on = [
    aws_bedrockagent_agent.main,
    aws_iam_role_policy.agent_kb
  ]
}

# ==========================================
# Agent Alias (Required for Invocation)
# ==========================================
resource "aws_bedrockagent_agent_alias" "main" {
  agent_id         = aws_bedrockagent_agent.main.id
  agent_alias_name = "production"
  description      = "Production alias for ${var.agent_name}"
  
  tags = local.common_tags

  depends_on = [ 
    aws_bedrockagent_agent.main,
    aws_bedrockagent_agent_knowledge_base_association.main
   ]
}