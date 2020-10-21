# GCP variables
variable "region" {
  description = "Region to deploy demo VM"
  default     = "us-west2"
}
variable "number_of_demo_instances" {
  description = "How many VMs do you want?"
  default     = 1
}
variable "project_id" {
  description = "Project to deploy resources"
}
 
variable "jenkins_workers_project_id" {
  description = "Project for Jenkins worker agents"
}
