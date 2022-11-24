# Define Variables
variable "organization" {
    description = "Organization and Workspace name"
}

variable "latitudesh_token" {
  description = "Latitude.sh API token"
}

variable "plan" {
  description = "Latitude.sh server plan"
  default = "c2.small.x86"
}

variable "region" {
  description = "Latitude.sh server region slug"
  default = "ASH"
}

variable "ssh_public_key" {
  description = "Latitude.sh SSH public key"
}

variable "plan_name" {
  description = "Plan name"
  default = "Solana Validator"
}

variable "plan_description" {
  description = "Plan description"
  default = "Solana Validator"
}

variable "plan_environment" {
  description = "Plan environment"
  default = "Development"
}

# Configure the Provider
provider "latitudesh" {
  auth_token = var.latitudesh_token
}

# Define Provider
terraform {
  required_providers {
    latitudesh = {
      source  = "latitudesh/latitudesh"
      version = "~> 0.1.4"
    }
  }

  backend "remote" {
    organization = vars.organization
    hostname     = "app.terraform.io"

    workspaces {
      prefix = vars.organization + "-"
    }
  }
}

# Create a Project
resource "latitudesh_project" "project" {
  name = vars.plan_name
  description = vars.plan_description
  environment = vars.environment
}

# Define SSH Keys
resource "latitudesh_ssh_key" "ssh_key" {
  project    = latitudesh_project.project.id
  name       = "Solana Validator Key"
  public_key = var.ssh_public_key
}

# Create a Server
resource "latitudesh_server" "server" {
  hostname         = vars.plan_name
  operating_system = "ubuntu_22_04_x64_lts"
  plan             = data.latitudesh_plan.plan.slug
  project          = latitudesh_project.project.id
  site             = data.latitudesh_region.region.slug
  ssh_keys         = [latitudesh_ssh_key.ssh_key.id]
}

output "public_ip" {
  value = server.primary_ip_v4
}