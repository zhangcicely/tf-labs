terraform {
  backend "gcs" {
    bucket = "student1gcp-istio-tfstate"
    credentials = "./creds/jenkins-sa.json"
  }
}
