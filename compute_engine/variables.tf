variable "project_id" {
  type = string
  description = "GCP project ID"
  default = ""
}

variable "region" {
  type = string
  default = "us-central1"
}

variable "zone" {
  type = string
  default = "us-central1-a"
}

variable "name" {
  type = string
  default = "terraform-instance"
}

variable "machine_type" {
  type = string
  default = "e2-micro"
}

variable "image" {
  type = string
  default = "ubuntu-os-cloud/ubuntu-2204-lts"
}
