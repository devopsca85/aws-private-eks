AWS CodePipeline CI/CD

Terraform is an infrastructure-as-code (IaC) tool that helps you create, update, and version your infrastructure in a secure and repeatable manner.
The scope of this pattern is to provide a guide and ready to use terraform configurations to setup validation pipelines with end-to-end tests based on AWS CodePipeline, AWS CodeBuild, AWS CodeCommit and Terraform.
The created pipeline uses the best practices for infrastructure validation and has the below stages
•	validate - This stage focuses on terraform IaC validation tools and commands such as terraform validate, terraform format, tfsec, tflint and checkov
•	plan - This stage creates an execution plan, which lets you preview the changes that Terraform plans to make to your infrastructure.
•	apply - This stage uses the plan created above to provision the infrastructure in the test account.
•	destroy - This stage destroys the infrastructure created in the above stage. Running these four stages ensures the integrity of the terraform configurations.
Directory Structure

|   |-- codebuild
|   |   |-- main.tf
|   |   `-- variables.tf
|   |-- codepipeline
|   |   |-- main.tf
|   |   `-- variables.tf

Installation:

Step 1: clone this repository

https://github.com/isramareddy/aws-private-eks.git

Step 2: Update the variables in terraform.tfvars based on your requirement. Make sure you ae updating the variables project_name, environment, source_repo_name, source_repo_branch, create_new_repo, stage_input and build_projects.
•	If you are planning to use an existing terraform CodeCommit repository, then update the variable create_new_repo as false and provide the name of your existing repo under the variable source_repo_name
•	If you are planning to create new terraform CodeCommit repository, then update the variable create_new_repo as true and provide the name of your new repo under the variable source_repo_name.
Step 3: Update remote backend configuration as required
Step 4: Configure the AWS Command Line Interface (AWS CLI) where this IaC is being executed. For more information, see Configuring the AWS CLI.0
Step 5: Initialize the directory. Run “terraform init”

Step 6: Start a Terraform run using the command terraform apply
Note: Sample terraform.tfvars are available in the examples directory. You may use the below command if you need to provide this sample tfvars as an input to the apply command.
terraform apply.


Pre-Requisites:
Step 1: You would get source_repo_clone_url_http as an output of the installation step. Clone the repository to your local.
git clone <source_repo_clone_url_http>
Step 2: Clone this repository.
https://github.com/isramareddy/aws-private-eks.git
Note: If you don't have git installed, install git.
Step 3: Copy the templates folder to the AWS CodeCommit sourcecode repository which contains the terraform code to be deployed.
cd /desktop/aws-codepipeline
Step 4: Update the variables in the template files with appropriate values and push the same.
Step 5: Trigger the pipeline created in the Installation step.
Note1: The IAM Role used by the newly created pipeline is very restrictive and follows the Principle of least privilege. Please update the IAM Policy with the required permissions. Alternatively, use the create_new_role = true
Requirements:

NAME                                        VERSION
TERRAFORM                             >= 1.0.0

Providers
NAME                                            VERSION
Aws			            >= 4.20.1

Resources
NAME				TYPE
aws_caller_identity.current	data source
aws_region.current		data source

Inputs
Name		Description	Type	Default	Required
build_project_source		aws/codebuild/standard:5.0	string	"CODEPIPELINE"	no
build_projects		Tags to be attached to the CodePipeline	list(string)	n/a	yes
builder_compute_type		Relative path to the Apply and Destroy build spec file	string	"BUILD_GENERAL1_SMALL"	no
builder_image		Docker Image to be used by codebuild	string	"aws/codebuild/amazonlinux2-x86_64-standard:5.0"	no
builder_image_pull_credentials_type		Image pull credentials type used by codebuild project	string	"CODEBUILD"	no
builder_type		Type of codebuild run environment	string	"LINUX_CONTAINER"	no
codepipeline_iam_role_name		Name of the IAM role to be used by the Codepipeline	string	"codepipeline-role"	no
create_new_repo		Whether to create a new repository. Values are true or false. Defaulted to true always.	bool	true	no
create_new_role		Whether to create a new IAM Role. Values are true or false. Defaulted to true always.	bool	true	no
environment		Environment in which the script is run. Eg: dev, prod, etc	string	n/a	yes
project_name		Unique name for this project	string	n/a	yes
repo_approvers_arn		ARN or ARN pattern for the IAM User/Role/Group that can be used for approving Pull Requests	string	n/a	yes
source_repo_branch		Default branch in the Source repo for which CodePipeline needs to be configured	string	n/a	yes
source_repo_name		Source repo name of the CodeCommit repository	string	n/a	yes
stage_input		Tags to be attached to the CodePipeline	list(map(any))	n/a	yes

License
This library is licensed under the MIT-0 License. See the LICENSE file.

