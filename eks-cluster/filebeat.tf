resource "kubernetes_daemonset" "filebeat" {
  metadata {
    name      = "filebeat-example"
    namespace = "kube-system"
    labels = {
      filebeat = "DemoApp"
    }
  }

  spec {
    selector {
      match_labels = {
        filebeat = "DemoApp"
      }
    }

    template {
      metadata {
        labels = {
          filebeat = "DemoApp"
        }
      }

      spec {
        container {
          image = "docker.elastic.co/beats/filebeat:7.14.0"
          name  = "filebeat"

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

          # liveness_probe {
          #   http_get {
          #     path = "/nginx_status"
          #     port = 80

          #     http_header {
          #       name  = "X-Custom-Header"
          #       value = "Awesome"
          #     }
          #   }

          #   initial_delay_seconds = 3
          #   period_seconds        = 3
          # }

        }
      }
    }
  }
}

# resource "kubernetes_config_map" "filebeat_configmap" {
#   metadata {
#     name = "my-config"
#   }

#   data = {
#     api_host             = "myhost:443"
#     db_host              = "dbhost:5432"
#     "my_config_file.yml" = "${file("${path.module}/my_config_file.yml")}"
#   }

#   binary_data = {
#     "my_payload.bin" = "${filebase64("${path.module}/my_payload.bin")}"
#   }
# }
