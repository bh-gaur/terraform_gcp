terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "7.25.0"
    }
  }
}

provider "google" {
    project = "" # TODO: Replace with your GCP project ID
    region  = "us-central1"
}


resource "google_compute_network" "vpc_network" {
    
    name = "vpc-network"
    auto_create_subnetworks = false

    description = "VPC Network for GCP Terraform Demo"
}

resource "google_compute_subnetwork" "subnet1" {
  name          = "my-subnet"
  ip_cidr_range = "10.0.1.0/24"
  region        = "asia-south1"

  secondary_ip_range {
    range_name = "pod-range"
    ip_cidr_range = "10.10.0.0/16"
  }
  
  network       = google_compute_network.vpc_network.id
}

resource "google_compute_subnetwork" "subnet2" {
  name          = "my-subnet2"
  ip_cidr_range = "10.0.2.0/24"
  region        = "asia-south1"
  
  secondary_ip_range {
    range_name = "svc-range"
    ip_cidr_range = "10.20.0.0/16"
  }
  
  network       = google_compute_network.vpc_network.id
}

resource "google_compute_subnetwork" "subnet3" {
  name          = "my-subnet3"
  ip_cidr_range = "10.0.3.0/24"
  region        = "asia-south1"
  
  network = google_compute_network.vpc_network.id
}

resource "google_compute_firewall" "allow_ssh" {
  name    = "allow-ssh"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"] # Be more restrictive in production!
  target_tags   = ["ssh-enabled"]
}
