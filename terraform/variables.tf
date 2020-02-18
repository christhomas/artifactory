data "aws_caller_identity" "current" {}

variable "aws_region" {
  description = "[string] (e.g eu-west-1): The aws region to execute this on"
  default = "eu-west-1"
}

variable "environment" {
  description = "[string] (staging|prod): One of the defined values"
  default = "staging"
}

variable "az_count" {
  description = "Number of AZs to cover in a given AWS region"
  default     = "2"
}

variable "app_name" {
  default = "artifactory"
}

variable "app_image" {
  description = "Docker image to run in the ECS cluster"
  default     = "christhomas/artifactory:latest"
}

variable "app_port" {
  description = "Port exposed by the docker image to redirect traffic to"
  default     = 8081
}

variable "app_count" {
  description = "Number of docker containers to run"
  default     = 1
}

variable "fargate_cpu" {
  description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
  default     = "2048"
}

variable "fargate_memory" {
  description = "Fargate instance memory to provision (in MiB)"
  default     = "4096"
}

variable "root_domain_name" {
  default = "mydomain.com"
}

variable "project_subrecord" {
  default = "packages"
}

variable "squad" {
  default = "mycompany"
}

variable "master_key" {
  default = "c08a641dcbeb76fb095cd7c242b4bda2"
}

variable "tags" {
  type = "map"
  default = {
    squad = "mycompany"
  }
}
