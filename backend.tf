terraform {
  backend "gcs" {
    bucket = "student1gcp-istio"
    credentials = "./creds/jenkins-sa.json"
  }
}
