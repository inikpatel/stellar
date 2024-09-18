/**
 * Copyright 2024 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#Current Project
data "google_project" "current" {}

data "google_compute_network" "my_vpc" {
  name = var.my_vpc
}

data "google_compute_subnetwork" "my_subnet" {
  name = var.my_subnet
}

# Custom service account with compute engine role  
resource "google_service_account" "compute" {
  account_id = var.compute_service_account_id
  project    = var.project_id
}

#Google KMS Module
module "kms" {
  source     = "../../../modules/kms"
  project_id = var.project_id
  keys       = var.keys

  iam = {
    "roles/cloudkms.cryptoKeyEncrypterDecrypter" = concat(
      [
        "serviceAccount:${google_service_account.compute.email}",
    ])
  }
  keyring = var.keyring
}

# Google Computer Firewall
resource "google_compute_firewall" "default" {
  name    = "allow-web"
  network = data.google_compute_network.my_vpc.self_link
  allow {
    protocol = "tcp"
    ports    = var.allowed_firewall_ports
  }
  # Allowing to connect only within the VPC CIDR Range
  source_ranges = var.allowed_source_ranges
}

#Bastion compute instance 
module "bastion-vm" {
  source     = "../../../modules/compute-vm"
  project_id = var.project_id
  zone       = var.zone
  name       = var.instance_name
  shielded_config = {
    enable_secure_boot          = true
    enable_vtpm                 = true
    enable_integrity_monitoring = true
  }
  instance_type = var.instance_type
  network_interfaces = [{
    network    = data.google_compute_network.my_vpc.self_link
    subnetwork = data.google_compute_subnetwork.my_subnet.self_link
  }]

  service_account = {
    email = google_service_account.compute.email
  }

  #Lockdown configuration
  encryption = {
    kms_key_self_link = module.kms.keys.bastion.id
  }
  attached_disks = [
    {
      auto_delete = true
      size        = 10
      name        = var.disk_name
      initialize_params = {
        image = var.image
      }
      kms_key_self_link = module.kms.keys.bastion.id
    }
  ]

  depends_on = [module.kms]
}

resource "google_kms_crypto_key_iam_member" "crypto_key" {
  crypto_key_id = module.kms.keys.bastion.id
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member        = "serviceAccount:service-${data.google_project.current.number}@compute-system.iam.gserviceaccount.com"
}
