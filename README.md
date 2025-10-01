# BedrockTest 

Terraform project to deploy an **AWS Bedrock Agent** with a connected **Knowledge Base** backed by S3 and OpenSearch.

The setup includes:

- Bedrock Agent
    
- Bedrock Knowledge Base
    
- S3 bucket (for documents)
    
- OpenSearch collection + index
    
- Configurable chunking strategies
    

![Architecture](arch.png)

## Prerequisites

- [Terraform ≥ 1.5.0](https://developer.hashicorp.com/terraform/downloads)
    
- AWS CLI configured (`aws configure`)
    
- Permissions to create:
    
    - S3 buckets
        
    - Bedrock resources
        
    - OpenSearch collections
        
    - IAM roles/policies
        

## Setup

1. **Clone the repo**
    

```bash
git clone -b dev https://github.com/dmdcl/BedrockTest.git
cd BedrockTest
```

2. **Initialize Terraform**
    

```bash
terraform init
```

3. **Create a `terraform.tfvars` file** in the root folder with your values:
    

```hcl
aws_region               = "us-east-1"
project_name             = "myproject"
environment              = "dev"
kb_s3_bucket_name        = "my-kb-bucket"   # Optional: if you want to bring your own bucket
agent_name               = "my-agent"
agent_model_id           = "anthropic.claude-v2"
agent_instruction        = "You are a helpful assistant."
agent_description        = "Agent for answering KB queries"
kb_name                  = "my-knowledge-base"
kb_description           = "KB with documents"
kb_embedding_model_id    = "amazon.titan-embed-text-v1"
opensearch_collection_name = "kb-collection"
opensearch_index_name    = "kb-index"
chunking_strategy        = "FIXED_SIZE"
fixed_size_max_tokens    = 300
fixed_size_overlap_percentage = 10
tags = {
  Owner = "me"
}
```

## Modules

- **`modules/s3.tf`** → Creates the S3 bucket if you don’t provide your own.
    
- **`modules/main.tf`** → Core logic: agent, KB, and OpenSearch.
    

## Configuration Notes

- By default, the repo **creates its own S3 bucket** for the KB.
    
- If you already have an S3 bucket you want to use:
    
    1. Pass its name via `kb_s3_bucket_name` in `terraform.tfvars`.
        
    2. **Uncomment** the corresponding lines in `modules/main.tf`:
        
    
    ```hcl
    data "aws_s3_bucket" "kb" {
      bucket = var.aws_s3_bucket
    }
    ```
    
    And **comment out** the `aws_s3_bucket.kb` resource in `modules/s3.tf`.
    

## Deploy

```bash
terraform plan
terraform apply
```

Confirm with `yes`. Terraform will create the agent, KB, S3 bucket (if enabled), and OpenSearch resources.

## Destroy

To tear everything down:

```bash
terraform destroy
```

## Upload Documents to KB

1. Copy your documents to the S3 bucket:
    

```bash
aws s3 cp ./documents s3://<kb-s3-bucket-name>/ --recursive
```

2. Start ingestion in Bedrock:
    

```bash
aws bedrock-agent start-ingestion-job \
  --knowledge-base-id <knowledge_base_id> \
  --data-source-id <data_source_id> \
  --region <aws_region>
```

You can get the values from the Terraform outputs:

```bash
terraform output
```

---

## Test Your Agent

```bash
aws bedrock-agent-runtime invoke-agent \
  --agent-id <agent_id> \
  --session-id test-session \
  --input-text "Hello, what can you help me with?" \
  --region <aws_region>
```

---

## Next Steps

- Monitor ingestion and queries via the AWS Console.
    
- Adjust chunking strategy, vector dimensions, and OpenSearch settings as needed.
