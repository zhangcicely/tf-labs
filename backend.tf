terraform {
  backend "gcs" {
    bucket = "autoinfra-20201020-student16xi-tfstate"
    credentials = "./creds/jenkins-sa.json"
  }
}
