provider "google" {
  project = ""
  region  = "us-central1"
}

terraform {
  backend "gcs" {
    bucket = "my-tf-state-bucket-1234534533534vvev"
    prefix = "terraform/state"
  }
}

resource "google_storage_bucket" "tf_state_bucket" {
  name     = "my-tf-state-bucket-1234534533534vvev"
  location = "US"
  
  storage_class = "STANDARD" // STANDARD, NEARLINE, ARCHIVE, COLDLINE

  versioning {
    enabled = true
  }
  
  lifecycle_rule {
    condition {
      age = 365
    }
    action {
      type = "Delete"
    }
  }
}
