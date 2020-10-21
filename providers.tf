provider "google" {
  project = var.project_id
  region  = var.region
  credentials = file("./creds/jenkins-sa.json")
}
