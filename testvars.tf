variable "project_name" {
  description = "Unique name for this project"
  type        = string
  default     = "my-terraform-project"  # Replace with your desired project name
}

variable "pipeline_s3_bucket_name" {
  description = "S3 bucket name to be used for storing the artifacts"
  type        = string
  default     = "aws-s3-bucket-pipeline-s3-bucket"  # Replace with your S3 bucket name
}

variable "github_repo_owner" {
  description = "GitHub repository owner"
  type        = string
  default     = "isramareddy"  # Replace with your GitHub repository owner
}

variable "github_repo_name" {
  description = "GitHub repository name"
  type        = string
  default     = "aws-private-eks"   # Replace with your GitHub repository name
}

variable "codepipeline_role_arn" {
  description = "ARN of the CodePipeline IAM role with full access"
  type        = string
  default     = "arn:aws:iam::aws:policy/AdministratorAccess"  # This grants full access, adjust as needed
}


variable "codepipeline_policy_arn" {
  description = "IAM policy ARN for granting CodePipeline permissions"
  type        = string
  default     = "arn:aws:iam::aws:policy/AdministratorAccess"  # You can adjust this default value
}

#variable "kms_key_arn" {
 # description = "ARN of the KMS key for encryption"
  #type        = string
  #default     = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-1234567890ab"  # Replace with your KMS key ARN
#}

variable "tags" {
  description = "Tags to be attached to the CodePipeline"
  type        = map(any)
  default     = {
    Environment = "Development",
    Project     = "MyProject",
  }
}

#variable "github_configuration" {
 # description = "GitHub configuration for the Source stage"
  #type        = map(string)
  #default     = {
   # owner      = "your-github-username",  # Replace with your GitHub username
   # repo       = "your-repo-name",  # Replace with your GitHub repository name
   # branch     = "master",  # Replace with your desired branch
   # oauth_token = "your-github-token",  # Replace with your GitHub OAuth token
  #}
#}