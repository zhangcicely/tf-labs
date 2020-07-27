
#resource "google_project_service" "project" {
#  project = var.project_id
#  service =  "[var.gcp_services]"
#}

resource "google_compute_instance" "demo" {
  name         = "demo-instance"
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



# Install Google Kubernetes Engine
module "gke" {
  source                     = "./modules/terraform-google-kubernetes-engine"
  project_id                 = var.project_id
  name                       = var.gke_cluster_name
  region                     = var.region
  zones                      = var.gke_zone
  network                    = var.gke_network
  subnetwork                 = var.gke_subnetwork
  ip_range_pods              = var.range_pods_name
  ip_range_services          = var.range_services_name
  http_load_balancing        = false
  horizontal_pod_autoscaling = true
  network_policy             = true

  node_pools = [
    {
      name               = var.node_pools_name
      machine_type       = var.node_pools_machine_type
      min_count          = var.node_pools_min_count
      max_count          = var.node_pools_max_count
      local_ssd_count    = 0
      disk_size_gb       = var.node_pools_disk_size
      disk_type          = "pd-standard"
      image_type         = "COS"
      auto_repair        = true
      auto_upgrade       = true
      service_account    = "gke-provision@jenkins-gke-0726-01.iam.gserviceaccount.com"
      preemptible        = false
      initial_node_count = var.initial_node_count
    },
  ]

  node_pools_oauth_scopes = {
    all = []

    default-node-pool = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }

  node_pools_labels = {
    all = {}

    default-node-pool = {
      default-node-pool = true
    }
  }

  node_pools_metadata = {
    all = {}

    default-node-pool = {
      node-pool-metadata-custom-value = "my-node-pool"
    }
  }

  node_pools_tags = {
    all = []

    default-node-pool = [
      "default-node-pool",
    ]
  }
}

# Install Jenkins
module "jenkins" {
  source  = "./modules/tf-gcp-jenkins"
  
# required variables
  jenkins_initial_password         = var.jenkins_initial_password
#  jenkins_initial_username         = var.jenkins_initial_username
  project_id		           = var.project_id
  region                           = var.region
  jenkins_instance_network         = var.jenkins_instance_network
  jenkins_instance_subnetwork      = var.jenkins_instance_subnetwork
  jenkins_instance_zone            = var.jenkins_instance_zone
  jenkins_workers_network          = var.jenkins_workers_network
  jenkins_workers_project_id       = var.jenkins_workers_project_id
  jenkins_workers_region           = var.jenkins_workers_region
}

output "test_vm_ip" {
  value = google_compute_instance.demo.network_interface.0.access_config.0.nat_ip
}


output "jenkins_instance_name" {
  description = "The name of the running Jenkins instance"
  value       = module.jenkins.jenkins_instance_name
}

output "jenkins_instance_public_ip" {
  description = "The public IP of the Jenkins instance"
  value       = module.jenkins.jenkins_instance_public_ip
}

output "jenkins__initial_username" {
  description = "The initial username assigned to Jenkins" 
  value       = module.jenkins.jenkins_instance_initial_username
}

output "jenkins_initial_password" {
  description = "The initial password assigned to Jenkins"
  value       = module.jenkins.jenkins_instance_initial_password
}
