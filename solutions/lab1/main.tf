terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
      version = "~> 2.13.0"
    }
  }
}

provider "docker" {}

resource "docker_image" "Apache_web" {
  name         = "httpd:latest"
  keep_locally = false
}

resource "docker_container" "web" {
  image = docker_image.Apache_web.latest
  name  = "Lab1-intro"
  ports {
    internal = 80
    external = 8080
  }
}
