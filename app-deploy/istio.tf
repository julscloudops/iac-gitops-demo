# resource "kubernetes_manifest" "gateway_frontend_gateway" {
#   manifest = {
#     "apiVersion" = "networking.istio.io/v1alpha1"
#     "kind"       = "Gateway"
#     "metadata" = {
#       "name" = "frontend-gateway"
#     }
#     "spec" = {
#       "selector" = {
#         "istio" = "ingressgateway"
#       }
#       "servers" = [
#         {
#           "hosts" = [
#             "*",
#           ]
#           "port" = {
#             "name"     = "http"
#             "number"   = 80
#             "protocol" = "HTTP"
#           }
#         },
#       ]
#     }
#   }
# }

# resource "kubernetes_manifest" "virtualservice_frontend_ingress" {
#   manifest = {
#     "apiVersion" = "networking.istio.io/v1alpha3"
#     "kind"       = "VirtualService"
#     "metadata" = {
#       "name" = "frontend-ingress"
#     }
#     "spec" = {
#       "gateways" = [
#         "frontend-gateway",
#       ]
#       "hosts" = [
#         "*",
#       ]
#       "http" = [
#         {
#           "route" = [
#             {
#               "destination" = {
#                 "host" = "frontend"
#                 "port" = {
#                   "number" = 80
#                 }
#               }
#             },
#           ]
#         },
#       ]
#     }
#   }
# }

# resource "kubernetes_manifest" "serviceentry_allow_egress_googleapis" {
#   manifest = {
#     "apiVersion" = "networking.istio.io/v1alpha3"
#     "kind"       = "ServiceEntry"
#     "metadata" = {
#       "name" = "allow-egress-googleapis"
#     }
#     "spec" = {
#       "hosts" = [
#         "accounts.google.com",
#         "*.googleapis.com",
#       ]
#       "ports" = [
#         {
#           "name"     = "http"
#           "number"   = 80
#           "protocol" = "HTTP"
#         },
#         {
#           "name"     = "https"
#           "number"   = 443
#           "protocol" = "HTTPS"
#         },
#       ]
#     }
#   }
# }

# resource "kubernetes_manifest" "serviceentry_allow_egress_google_metadata" {
#   manifest = {
#     "apiVersion" = "networking.istio.io/v1alpha3"
#     "kind"       = "ServiceEntry"
#     "metadata" = {
#       "name" = "allow-egress-google-metadata"
#     }
#     "spec" = {
#       "addresses" = [
#         "169.254.169.254",
#       ]
#       "hosts" = [
#         "metadata.google.internal",
#       ]
#       "ports" = [
#         {
#           "name"     = "http"
#           "number"   = 80
#           "protocol" = "HTTP"
#         },
#         {
#           "name"     = "https"
#           "number"   = 443
#           "protocol" = "HTTPS"
#         },
#       ]
#     }
#   }
# }

# resource "kubernetes_manifest" "virtualservice_frontend" {
#   manifest = {
#     "apiVersion" = "networking.istio.io/v1alpha3"
#     "kind"       = "VirtualService"
#     "metadata" = {
#       "name" = "frontend"
#     }
#     "spec" = {
#       "hosts" = [
#         "frontend.default.svc.cluster.local",
#       ]
#       "http" = [
#         {
#           "route" = [
#             {
#               "destination" = {
#                 "host" = "frontend"
#                 "port" = {
#                   "number" = 80
#                 }
#               }
#             },
#           ]
#         },
#       ]
#     }
#   }
# }
