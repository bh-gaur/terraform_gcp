terraform {
  backend "gcs" {
    bucket = "my-tf-state-bucket-1234534533534vvev"
    prefix = "vpc-network/dev"
    
  }
}