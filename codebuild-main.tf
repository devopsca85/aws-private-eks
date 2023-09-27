provider "aws" {
  region = "ap-south-1"  # Change this to your desired AWS region
}

resource "aws_codebuild_source_credential" "github" {
  auth_type = "PERSONAL_ACCESS_TOKEN"
  server_type = "GITHUB"
  token = var.github_personal_access_token
}

resource "aws_codebuild_project" "my_codebuild_project" {
  name          = var.codebuild_project
  description   = "My CodeBuild Project"
  service_role  = aws_iam_role.codebuild_role.arn
  badge_enabled = true                     

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:5.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"

    environment_variable {
      name  = "GITHUB_REPO_OWNER"
      value = var.github_repo_owner
    }

    environment_variable {
      name  = "GITHUB_REPO_NAME"
      value = var.github_repo_name
    }
  }

  source {
    type            = "GITHUB"
    location        = "https://github.com/${var.github_repo_owner}/${var.github_repo_name}.git"
    git_clone_depth = 1
    #OAuthToken     = "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"  # Replace with your GitHub personal access token
    #Branch          = "master"  # Replace with your desired branch

    #auth {
      #type     = "personal_access_token"
      #resource = "https://github.com"
    #}
  }
}

resource "aws_iam_role" "codebuild_role" {
  name = "codebuild-service-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      }
    }
  ]
}
EOF
}

resource "aws_iam_policy_attachment" "codebuild_permissions" {
  name       = "codebuild permissions"
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"  # Attach the necessary policies
  roles      = [aws_iam_role.codebuild_role.name]
}

resource "aws_iam_policy" "codebuild_policy" {
  name        = "CodeBuildPolicy"
  description = "Permissions for CodeBuild projects"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = [
          "codebuild:BatchGetBuilds",
          "codebuild:StartBuild",
          "codebuild:StopBuild",
          "codebuild:RetryBuild",
          "codebuild:ListBuilds",
          "codebuild:ListBuildsForProject",
          "codebuild:ListCuratedEnvironmentImages",
        ],
        Resource = "*",
      },
      {
        Effect   = "Allow",
        Action   = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
        ],
        Resource = "arn:aws:logs:*:*:*",
      },
    ],
  })
}