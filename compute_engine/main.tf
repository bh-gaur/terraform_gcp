terraform {
  backend "gcs" {
    bucket  = "my-tf-state-bucket-1234534533534vvev"
    prefix  = "compute/dev"
  }
}

resource "google_compute_instance" "vm_instance" {
  name         = var.name
  machine_type = var.machine_type
  zone         = var.zone
  
  tags = ["web-server"]
  
  boot_disk {
    initialize_params {
      image = var.image
    }
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral public IP
    }
  }

  hostname = "test.instance"

  metadata = {
    ssh-keys = "bhola:${file("~/.ssh/bhola/bhola-public-key.pub")}"
  }

  metadata_startup_script = <<-EOT
    echo hi > /test.txt
    sudo apt update
    sudo apt install -y nginx
    sudo systemctl start nginx
    sudo systemctl enable nginx
  EOT
  deletion_protection     = false
}


resource "google_compute_firewall" "allow_http_ssh" {
  name    = "allow-http-ssh"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["22", "80"]
  }

  source_ranges = ["0.0.0.0/0"]
  
  target_tags = ["web-server"]
}

output "instance_name" {
  value = google_compute_instance.vm_instance.name
}

output "instance_ip" {
  value = google_compute_instance.vm_instance.network_interface[0].access_config[0].nat_ip
}
