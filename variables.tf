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

# GKE variables
variable "gke_cluster_name" {
  description = "Name of GKE cluster"
  default     = "gke-jenkins"
}

variable "gke_zone" {
  description  = "Zone for GKE cluster"
  type    = list(string)
  default = ["us-west2-a"]
}

variable "gcp_services" {
  description  = "GCP API services"
  type    = list(string)
  default = ["compute.googleapis.com, container.googleapis.com"]
}

variable "gke_network" {
  description  = "Network to deploy GKE"
  default      = "default"
}

variable "gke_subnetwork" {
  description  = "GKE Subnetwork"
  default      = "default"
}

variable "range_pods_name" {
  default      = "gke-jenkins-pods"
}

variable "range_services_name" {
  default      = "gke-jenkins-services"
}

variable "node_pools_name" {
  default     = "default-node-pool"
}

variable "node_pools_machine_type" {
  default     = "e2-medium"
}

variable "node_pools_min_count" { 
  default     = 1
}

variable "node_pools_max_count" {
  default     = 1
}

variable "node_pools_disk_size" {
  default     = 100
}

variable  "initial_node_count" {
  default         = 3
}


  
