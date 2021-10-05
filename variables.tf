variable "profile" {
  description = "AWS Profile used to create the resoources"
  default     = "globee"
}

variable "region" {
  description = "Region in which to create the resources"
  default     = "eu-west-1"
}

variable "service" {
  description = "The service name abbreviation of the service"
}

variable "team" {
  description = "Department or Owner of the resource"
}

variable "description" {
  description = "Description of the Service"
}

## codebuild vars
variable "code_build_environment_vars" {
  description = "Map of the Environment Variables needed for the CodeBuild Project"
  default = {}
}

variable "subnet_id1" {
  description = "Subnet(s) in which the ECS is deployed and where CodeBuild projects builds"
  default     = "subnet-0f26f121e8f5a8774"
}

variable "subnet_id2" {
  description = "Subnet(s) in which the ECS is deployed and where CodeBuild projects builds"
  default     = "subnet-060a023c0808d3b93"
}

variable "subnet_id3" {
  description = "Subnet(s) in which the ECS is deployed and where CodeBuild projects builds"
  default     = "subnet-0ae32650dc8cc5aab"
}

variable "runtime_version" {
  description = "Java Runtime Version that gets configured in the buildspec"
  default     = "openjdk11" 
}

variable "sns_approval_topic_arn" {
  description = "The SNS topic where approval notifications are sent"
  default     = "arn:aws:sns:eu-west-1:834366213304:slack-deploy-approvals-topic"
}

## shared ecs variables

variable "reserved_task_memory" {
  description = "The soft limit (in MiB) of memory to reserve for the container"
  default     = "512" 
}

variable "container_port" {
  description = "The port that the application in the container is published on"
}

variable "ecs_healthcheck_endpoint" {
  description = "Endpoint used to monitor the availability of the container"
  default     = "/"
}

variable "host_port" {
  description = "The port the container is mapped onto from the host. Can be left empty since these are Fargate containers"
}

variable "vpc_id" {
  description = "The VPC where resources are created"
  default     = "vpc-607f9619"
}

## dev ecs task definition variables
variable "ecs_cluster_name_dev" {
  description = "Name of the ECS Development Cluster"
  default     = "dev-cluster" 
}

variable "dev_ecs_environment_vars" {
  description = "Map of the Environment Variables needed for the dev ECS container"
  default = {}
}

variable "dev_ecs_ssm_secrets" {
  description = "Map of the SSM Parameter Store Secretes needed for the dev ECS container"
  default = {}
}

variable "dev_container_desired_count" {
  description = "Desired amount of containers for the dev ECS container"
  default     = 1 
}