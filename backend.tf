terraform {
  backend "gcs" {
    bucket = "jscloud-shell-tfstate"
    credentials = "./creds/serviceaccount.json"
  }
}
