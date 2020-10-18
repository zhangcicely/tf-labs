resource "google_compute_instance" "demo" {
  count        = var.number_of_demo_instances
  name         = "demo-instance-${count.index}"
  machine_type = "n1-standard-1"
  zone         = "us-west1-a"
  metadata = {
   ssh-keys = "ubuntu:${file("~/.ssh/google_compute_engine.pub")}"
}

  # boot disk specifications
  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-1804-lts" 
    }
  }

// Make sure flask is installed on all new instances for later steps
 metadata_startup_script = "sudo apt-get update; sudo apt-get install -yq build-essential python-pip rsync nginx; pip install flask"

  # networks to attach to the VM
  network_interface {
    network = "default"
    access_config {} // use ephemeral public IP
  }
}

resource "google_compute_firewall" "demo" {
  name    = "allow-demo-tcp-80"
  network = "default"
  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
  source_ranges = ["0.0.0.0/0"]
}

# Install Jenkins
#module "jenkins" {
#  source  = "./modules/tf-gcp-jenkins"
  
# required variables
#  jenkins_initial_password         = var.jenkins_initial_password
#  jenkins_initial_username         = var.jenkins_initial_username
#  project_id		           = var.project_id
#  region                           = var.region
#  jenkins_instance_network         = var.jenkins_instance_network
#  jenkins_instance_subnetwork      = var.jenkins_instance_subnetwork
#  jenkins_instance_zone            = var.jenkins_instance_zone
#  jenkins_workers_network          = var.jenkins_workers_network
#  jenkins_workers_project_id       = var.jenkins_workers_project_id
#  jenkins_workers_region           = var.jenkins_workers_region
#}

output "demo_vm_ip" {
  value = [google_compute_instance.demo.*.network_interface.0.access_config.0.nat_ip]
}


#output "jenkins_instance_name" {
#  description = "The name of the running Jenkins instance"
#  value       = module.jenkins.jenkins_instance_name
#}

#output "jenkins_instance_public_ip" {
#  description = "The public IP of the Jenkins instance"
#  value       = module.jenkins.jenkins_instance_public_ip
#}

#output "jenkins__initial_username" {
#  description = "The initial username assigned to Jenkins" 
#  value       = module.jenkins.jenkins_instance_initial_username
#}

#output "jenkins_initial_password" {
#  description = "The initial password assigned to Jenkins"
#  value       = module.jenkins.jenkins_instance_initial_password
#}
