#TODO: restructure variables files. break up into specific vars for resources
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

#TODO: rename to build_env_variables
variable "code_build_environment_vars" {
  description = "Environment Variable Key Value Pairs"
  default = {}
}

variable "subnet_id1" {
  default = "subnet-0f26f121e8f5a8774"
}

variable "subnet_id2" {
  default = "subnet-060a023c0808d3b93"
}

variable "subnet_id3" {
  default = "subnet-0ae32650dc8cc5aab"
}

variable "runtime_version" {
  description = ""
  default     = "openjdk11" 
}

## shared ecs variables

variable "reserved_task_memory" {
  description = ""
  default     = "512" 
}

variable "container_port" {
  description = ""
}

variable "host_port" {
  description = ""
}

variable "vpc_id" {
  description = ""
  default     = "vpc-607f9619"
}

## dev ecs task definition variables
variable "ecs_cluster_name_dev" {
  description = ""
  default     = "dev-cluster" 
}

variable "dev_ecs_environment_vars" {
  description = ""
  default = {}
}

variable "dev_ecs_ssm_secrets" {
  description = ""
  default = {}
}

variable "dev_container_desired_count" {
  description = ""
  default     = 1 
}

variable "sns_approval_topic_arn" {
  description = ""
  default     = "arn:aws:sns:eu-west-1:834366213304:slack-deploy-approvals-topic"
}