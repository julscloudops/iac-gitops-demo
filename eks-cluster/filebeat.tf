# resource "kubernetes_daemonset" "example" {
#   metadata {
#     name      = "terraform-example"
#     namespace = "something"
#     labels = {
#       test = "MyExampleApp"
#     }
#   }
