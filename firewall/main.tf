provider "google" {
  project = ""
  region  = "us-central1"
}
terraform {
  backend "gcs" {
    bucket = "my-tf-state-bucket-1234534533534vvev"
    prefix = "firewall/dev"
  }
}




data "external" "my_ip" {
  program = ["sh", "-c", "curl -s https://whatismyip.akamai.com | jq -n '{ip: $input}' --arg input \"$(cat)\""]
}

data "google_compute_network" "default" {
  name = "default"
}

resource "google_compute_firewall" "my-custom-firewall" {
  name    = "my-custom-firewall"
  network = data.google_compute_network.default.self_link

  allow {
    protocol = "tcp"
    ports    = ["22", "80"]
  }

  source_ranges = ["${data.external.my_ip.result.ip}/32"]
  
  target_tags = ["my-custom-firewall"]
}
