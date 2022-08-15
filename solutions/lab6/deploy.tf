resource "kubernetes_deployment" "nginx" {
  metadata {
    name = "nginx-lab6"
    labels = {
      App = "nginx-lab6"
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        App = "nginx-lab6"
      }
    }
    template {
      metadata {
        labels = {
          App = "nginx-lab6"
        }
      }
      spec {
        container {
          image = "nginx:1.22.0" # 1.23.0 is currently latest at time of publishing; 
          name  = "example"

          port {
            container_port = 80
          }

          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }
        }
      }
    }
  }
}
