provider "aws" {
  region = "ap-south-1"  # Change this to your desired AWS region
}

resource "aws_s3_bucket" "pipeline_s3_bucket" {
  bucket = var.pipeline_s3_bucket_name
  acl    = "private"  # Adjust the ACL as needed
  #region = "ap-south-1"  # Specify the region as us-east-1
}

#resource "aws_codestarconnections_connection" "github_connection" {
 # name       = "my-github-connection"  # Replace with a unique name
 # provider_type = "GitHub"
 # owner_account_id = "400926585409"
  #connection_properties = {
    #"Host"       = "github.com",
    #"AccessToken" = "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"
  #}
#}

resource "aws_codepipeline" "terraform_pipeline" {
  name     = "my-terraform-pipeline"  # Replace with your desired pipeline name
  role_arn = aws_iam_role.codepipeline_role.arn
  tags     = var.tags

  artifact_store {
    location = "aws-s3-bucket-pipeline-s3-bucket"  # Replace with your S3 bucket name
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Fetch-GitHub-Source"
      category         = "Source"
      owner            = "ThirdParty"
      version          = "1"
      #provider         = "CodeStarSourceConnection"
      provider         = "GitHub"
      output_artifacts = ["SourceOutput"]
      run_order        = 1

      configuration = {
        Owner             = var.github_repo_owner  # Replace with your GitHub username
        Repo              = var.github_repo_name   # Replace with your GitHub repository name
        #ConnectionArn  = "aws_codestarconnections_connection.github_connection.arn"  # Use the GitHub CodeStar Connection ARN
        #FullRepository = "https://github.com/${var.github_repo_owner}/${var.github_repo_name}"  # Specify the GitHub repository URL
        OAuthToken        = "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"  # Replace with your GitHub personal access token
        Branch         = "master"  # Replace with your desired branch
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build-Action"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["SourceOutput"]
      output_artifacts = ["BuildOutput"]
      version          = "1"
      run_order        = 2

      configuration = {
        ProjectName = "test-build"  # Replace with your CodeBuild project name
        #Region      = "ap-south-1"  # Update the region to required region
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name             = "Deploy-Action"
      category         = "Deploy"
      owner            = "AWS"
      provider         = "CodeDeploy"
      input_artifacts  = ["BuildOutput"]
      #output_artifacts = ["DeployOutput"]
      version          = "1"
      run_order        = 3
      configuration = {
        ApplicationName     = "my-codedeploy-application"  # Replace with your CodeDeploy application name
        DeploymentGroupName = "my-codedeploy-group"  # Replace with your CodeDeploy deployment group name
      }
    }
  }
}

#resource "aws_iam_policy" "codestar_connections_policy" {
 # name        = "CodeStarConnectionsPolicy"
  #description = "Policy to grant permissions for AWS CodeStar Connections"
  #policy      = jsonencode({
   # Version: "2012-10-17",
    #Statement: [
     # {
      #  Effect: "Allow",
       # Action: [
        #  "codestar-connections:ListConnections",
         # "codestar-connections:GetConnection",
          #"codestar-connections:ListTagsForConnection",
          #"codestar-connections:TagResource",
          #"codestar-connections:UntagResource"
        #],
        #Resource: "*"
      #},
      #{
       # Effect: "Allow",
       # Action: "codestar-connections:PassConnection",
       # Resource: "your-github-connection-arn"  # Replace with your GitHub connection ARN
      #},
      #{
       # Effect: "Allow",
       # Action: [
       #   "codestar-connections:UpdateConnection",
       #   "codestar-connections:DeleteConnection",
       #   "codestar-connections:GetConnectionStatus"
       # ],
       # Resource: "*"
      #}
    #]
  #})
#}


resource "aws_iam_role" "codepipeline_role" {
  name = "MyCodePipelineRole"  # Replace with your desired role name
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "codepipeline.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_policy_attachment" "codepipeline_full_access" {
  name       = "codepipeline permissions"
  policy_arn = var.codepipeline_policy_arn
  roles      = [aws_iam_role.codepipeline_role.name]
}

#resource "aws_iam_policy_attachment" "codepipeline_codestar_attachment" {
 # name       = "codepipeline-codestar-attachment"
 # policy_arn = "aws_iam_policy"
  #policy_arn = aws_iam_policy.codestar_connections_policy.arn
  #roles      = [aws_iam_role.codepipeline_role.name]
#}
