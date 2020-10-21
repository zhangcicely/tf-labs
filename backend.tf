terraform {
  backend "gcs" {
    bucket = "instructor-20201020-student1xi-tfstate"
    credentials = "./creds/serviceaccount.json"
  }
}
