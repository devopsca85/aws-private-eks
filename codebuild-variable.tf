variable "github_personal_access_token" {
  description = "GitHub OAuth token for CodeBuild"
  type        = string
  default     = "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"
}

variable "github_repo_owner" {
  description = "GitHub repository owner (e.g., your username or organization)"
  type        = string
  default     = "isramareddy"
}

variable "github_repo_name" {
  description = "GitHub repository name"
  type        = string
  default     = "aws-private-eks"
}

variable "codebuild_project" {
  description = "Name of the AWS CodeBuild project"
  type        = string
  default     = "test-build"
}
