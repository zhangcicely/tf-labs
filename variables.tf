# GCP variables
variable "region" {
  description = "Region to deploy demo VM"
  default     = "us-west2"
}

# Jenkins variables

variable "jenkins_initial_password" {
  description = "Jenkins user password" 
  default     = "password"
}

variable "project_id" {
  description = "Project for Jenkins VM"
}

variable "jenkins_instance_network" {
  description = "Network for Jenkins instance"
  default     = "default"
}

variable "jenkins_instance_subnetwork" {
  description = "Subnetwork for Jenkins instance"
  default     = "default"
}

variable "jenkins_instance_zone" {
  description = "Jenkins VM zone"
  default     = "us-west2-a"
}

variable "jenkins_workers_network" {
  description = "Network for workers"
  default     = "default"
}

variable "jenkins_workers_project_id" {
  description = "Workers Project" 
}

variable "jenkins_workers_region" {
  description = "Workers region"
  default     = "us-west2"
}
