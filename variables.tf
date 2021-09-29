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

variable "environment_vars" {
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