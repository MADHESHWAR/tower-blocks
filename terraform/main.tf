terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {
  host = "npipe:////./pipe/docker_engine"
}

variable "container_name" {}
variable "image_name" {}
variable "external_port" {}

resource "docker_image" "app" {
  name         = var.image_name
  keep_locally = true
}

resource "docker_container" "web" {
  name  = var.container_name
  image = docker_image.app.image_id

  ports {
    internal = 80
    external = var.external_port
  }

  lifecycle {
    create_before_destroy = true
  }
}
