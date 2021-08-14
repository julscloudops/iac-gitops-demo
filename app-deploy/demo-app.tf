
resource "kubernetes_namespace" "demo_app" {
  metadata {
    name = "demo-app"
  }
}

resource "kubernetes_manifest" "deployment_emailservice" {
  manifest = {
    "apiVersion" = "apps/v1"
    "kind" = "Deployment"
    "metadata" = {
      "name" = "emailservice"
      "namespace" = "demo-app"
    }
    "spec" = {
      "selector" = {
        "matchLabels" = {
          "app" = "emailservice"
        }
      }
      "template" = {
        "metadata" = {
          "labels" = {
            "app" = "emailservice"
          }
        }
        "spec" = {
          "containers" = [
            {
              "env" = [
                {
                  "name" = "PORT"
                  "value" = "8080"
                },
                {
                  "name" = "DISABLE_PROFILER"
                  "value" = "1"
                },
              ]
              "image" = "gcr.io/google-samples/microservices-demo/emailservice:v0.2.4"
              "livenessProbe" = {
                "exec" = {
                  "command" = [
                    "/bin/grpc_health_probe",
                    "-addr=:8080",
                  ]
                }
                "periodSeconds" = 5
              }
              "name" = "server"
              "ports" = [
                {
                  "containerPort" = 8080
                  "protocol" = "TCP"
                },
              ]
              "readinessProbe" = {
                "exec" = {
                  "command" = [
                    "/bin/grpc_health_probe",
                    "-addr=:8080",
                  ]
                }
                "periodSeconds" = 5
              }
              "resources" = {
                "limits" = {
                  "cpu" = "200m"
                  "memory" = "128Mi"
                }
                "requests" = {
                  "cpu" = "100m"
                  "memory" = "64Mi"
                }
              }
            },
          ]
          "serviceAccountName" = "default"
          "terminationGracePeriodSeconds" = 5
        }
      }
    }
  }
}

resource "kubernetes_manifest" "service_emailservice" {
  manifest = {
    "apiVersion" = "v1"
    "kind" = "Service"
    "metadata" = {
      "name" = "emailservice"
      "namespace" = "demo-app"
    }
    "spec" = {
      "ports" = [
        {
          "name" = "grpc"
          "port" = 5000
          "targetPort" = 8080
          "protocol" = "TCP"
        },
      ]
      "selector" = {
        "app" = "emailservice"
      }
      "type" = "ClusterIP"
    }
  }
}

resource "kubernetes_manifest" "deployment_checkoutservice" {
  manifest = {
    "apiVersion" = "apps/v1"
    "kind" = "Deployment"
    "metadata" = {
      "name" = "checkoutservice"
      "namespace" = "demo-app"
    }
    "spec" = {
      "selector" = {
        "matchLabels" = {
          "app" = "checkoutservice"
        }
      }
      "template" = {
        "metadata" = {
          "labels" = {
            "app" = "checkoutservice"
          }
        }
        "spec" = {
          "containers" = [
            {
              "env" = [
                {
                  "name" = "PORT"
                  "value" = "5050"
                },
                {
                  "name" = "PRODUCT_CATALOG_SERVICE_ADDR"
                  "value" = "productcatalogservice:3550"
                },
                {
                  "name" = "SHIPPING_SERVICE_ADDR"
                  "value" = "shippingservice:50051"
                },
                {
                  "name" = "PAYMENT_SERVICE_ADDR"
                  "value" = "paymentservice:50051"
                },
                {
                  "name" = "EMAIL_SERVICE_ADDR"
                  "value" = "emailservice:5000"
                },
                {
                  "name" = "CURRENCY_SERVICE_ADDR"
                  "value" = "currencyservice:7000"
                },
                {
                  "name" = "CART_SERVICE_ADDR"
                  "value" = "cartservice:7070"
                },
              ]
              "image" = "gcr.io/google-samples/microservices-demo/checkoutservice:v0.2.4"
              "livenessProbe" = {
                "exec" = {
                  "command" = [
                    "/bin/grpc_health_probe",
                    "-addr=:5050",
                  ]
                }
              }
              "name" = "server"
              "ports" = [
                {
                  "containerPort" = 5050
                  "protocol" = "TCP"
                },
              ]
              "readinessProbe" = {
                "exec" = {
                  "command" = [
                    "/bin/grpc_health_probe",
                    "-addr=:5050",
                  ]
                }
              }
              "resources" = {
                "limits" = {
                  "cpu" = "200m"
                  "memory" = "128Mi"
                }
                "requests" = {
                  "cpu" = "100m"
                  "memory" = "64Mi"
                }
              }
            },
          ]
          "serviceAccountName" = "default"
        }
      }
    }
  }
}

resource "kubernetes_manifest" "service_checkoutservice" {
  manifest = {
    "apiVersion" = "v1"
    "kind" = "Service"
    "metadata" = {
      "name" = "checkoutservice"
      "namespace" = "demo-app"
    }
    "spec" = {
      "ports" = [
        {
          "name" = "grpc"
          "port" = 5050
          "targetPort" = 5050
          "protocol" = "TCP"
        },
      ]
      "selector" = {
        "app" = "checkoutservice"
      }
      "type" = "ClusterIP"
    }
  }
}

resource "kubernetes_manifest" "deployment_recommendationservice" {
  manifest = {
    "apiVersion" = "apps/v1"
    "kind" = "Deployment"
    "metadata" = {
      "name" = "recommendationservice"
      "namespace" = "demo-app"
    }
    "spec" = {
      "selector" = {
        "matchLabels" = {
          "app" = "recommendationservice"
        }
      }
      "template" = {
        "metadata" = {
          "labels" = {
            "app" = "recommendationservice"
          }
        }
        "spec" = {
          "containers" = [
            {
              "env" = [
                {
                  "name" = "PORT"
                  "value" = "8080"
                },
                {
                  "name" = "PRODUCT_CATALOG_SERVICE_ADDR"
                  "value" = "productcatalogservice:3550"
                },
              ]
              "image" = "gcr.io/google-samples/microservices-demo/recommendationservice:v0.2.4"
              "livenessProbe" = {
                "exec" = {
                  "command" = [
                    "/bin/grpc_health_probe",
                    "-addr=:8080",
                  ]
                }
                "periodSeconds" = 5
              }
              "name" = "server"
              "ports" = [
                {
                  "containerPort" = 8080
                  "protocol" = "TCP"
                },
              ]
              "readinessProbe" = {
                "exec" = {
                  "command" = [
                    "/bin/grpc_health_probe",
                    "-addr=:8080",
                  ]
                }
                "periodSeconds" = 5
              }
              "resources" = {
                "limits" = {
                  "cpu" = "200m"
                  "memory" = "450Mi"
                }
                "requests" = {
                  "cpu" = "100m"
                  "memory" = "220Mi"
                }
              }
            },
          ]
          "serviceAccountName" = "default"
          "terminationGracePeriodSeconds" = 5
        }
      }
    }
  }
}

resource "kubernetes_manifest" "service_recommendationservice" {
  manifest = {
    "apiVersion" = "v1"
    "kind" = "Service"
    "metadata" = {
      "name" = "recommendationservice"
      "namespace" = "demo-app"
    }
    "spec" = {
      "ports" = [
        {
          "name" = "grpc"
          "port" = 8080
          "targetPort" = 8080
          "protocol" = "TCP"
        },
      ]
      "selector" = {
        "app" = "recommendationservice"
      }
      "type" = "ClusterIP"
    }
  }
}

resource "kubernetes_manifest" "deployment_frontend" {
  manifest = {
    "apiVersion" = "apps/v1"
    "kind" = "Deployment"
    "metadata" = {
      "name" = "frontend"
      "namespace" = "demo-app"
    }
    "spec" = {
      "selector" = {
        "matchLabels" = {
          "app" = "frontend"
        }
      }
      "template" = {
        "metadata" = {
          "annotations" = {
            "sidecar.istio.io/rewriteAppHTTPProbers" = "true"
          }
          "labels" = {
            "app" = "frontend"
          }
        }
        "spec" = {
          "containers" = [
            {
              "env" = [
                {
                  "name" = "PORT"
                  "value" = "8080"
                },
                {
                  "name" = "PRODUCT_CATALOG_SERVICE_ADDR"
                  "value" = "productcatalogservice:3550"
                },
                {
                  "name" = "CURRENCY_SERVICE_ADDR"
                  "value" = "currencyservice:7000"
                },
                {
                  "name" = "CART_SERVICE_ADDR"
                  "value" = "cartservice:7070"
                },
                {
                  "name" = "RECOMMENDATION_SERVICE_ADDR"
                  "value" = "recommendationservice:8080"
                },
                {
                  "name" = "SHIPPING_SERVICE_ADDR"
                  "value" = "shippingservice:50051"
                },
                {
                  "name" = "CHECKOUT_SERVICE_ADDR"
                  "value" = "checkoutservice:5050"
                },
                {
                  "name" = "AD_SERVICE_ADDR"
                  "value" = "adservice:9555"
                },
              ]
              "image" = "gcr.io/google-samples/microservices-demo/frontend:v0.2.4"
              "livenessProbe" = {
                "httpGet" = {
                  "httpHeaders" = [
                    {
                      "name" = "Cookie"
                      "value" = "shop_session-id=x-liveness-probe"
                    },
                  ]
                  "path" = "/_healthz"
                  "port" = 8080
                }
                "initialDelaySeconds" = 10
              }
              "name" = "server"
              "ports" = [
                {
                  "containerPort" = 8080
                  "protocol" = "TCP"
                },
              ]
              "readinessProbe" = {
                "httpGet" = {
                  "httpHeaders" = [
                    {
                      "name" = "Cookie"
                      "value" = "shop_session-id=x-readiness-probe"
                    },
                  ]
                  "path" = "/_healthz"
                  "port" = 8080
                }
                "initialDelaySeconds" = 10
              }
              "resources" = {
                "limits" = {
                  "cpu" = "200m"
                  "memory" = "128Mi"
                }
                "requests" = {
                  "cpu" = "100m"
                  "memory" = "64Mi"
                }
              }
            },
          ]
          "serviceAccountName" = "default"
        }
      }
    }
  }
}

resource "kubernetes_manifest" "service_frontend" {
  manifest = {
    "apiVersion" = "v1"
    "kind" = "Service"
    "metadata" = {
      "name" = "frontend"
      "namespace" = "demo-app"
    }
    "spec" = {
      "ports" = [
        {
          "name" = "http"
          "port" = 80
          "targetPort" = 8080
          "protocol" = "TCP"
        },
      ]
      "selector" = {
        "app" = "frontend"
      }
      "type" = "ClusterIP"
    }
  }
}

resource "kubernetes_manifest" "service_frontend_external" {
  manifest = {
    "apiVersion" = "v1"
    "kind" = "Service"
    "metadata" = {
      "name" = "frontend-external"
      "namespace" = "demo-app"
    }
    "spec" = {
      "ports" = [
        {
          "name" = "http"
          "port" = 80
          "targetPort" = 8080
          "protocol" = "TCP"
        },
      ]
      "selector" = {
        "app" = "frontend"
      }
      "type" = "LoadBalancer"
    }
  }
}

resource "kubernetes_manifest" "deployment_paymentservice" {
  manifest = {
    "apiVersion" = "apps/v1"
    "kind" = "Deployment"
    "metadata" = {
      "name" = "paymentservice"
      "namespace" = "demo-app"
    }
    "spec" = {
      "selector" = {
        "matchLabels" = {
          "app" = "paymentservice"
        }
      }
      "template" = {
        "metadata" = {
          "labels" = {
            "app" = "paymentservice"
          }
        }
        "spec" = {
          "containers" = [
            {
              "env" = [
                {
                  "name" = "PORT"
                  "value" = "50051"
                },
              ]
              "image" = "gcr.io/google-samples/microservices-demo/paymentservice:v0.2.4"
              "livenessProbe" = {
                "exec" = {
                  "command" = [
                    "/bin/grpc_health_probe",
                    "-addr=:50051",
                  ]
                }
              }
              "name" = "server"
              "ports" = [
                {
                  "containerPort" = 50051
                  "protocol" = "TCP"
                },
              ]
              "readinessProbe" = {
                "exec" = {
                  "command" = [
                    "/bin/grpc_health_probe",
                    "-addr=:50051",
                  ]
                }
              }
              "resources" = {
                "limits" = {
                  "cpu" = "200m"
                  "memory" = "128Mi"
                }
                "requests" = {
                  "cpu" = "100m"
                  "memory" = "64Mi"
                }
              }
            },
          ]
          "serviceAccountName" = "default"
          "terminationGracePeriodSeconds" = 5
        }
      }
    }
  }
}

resource "kubernetes_manifest" "service_paymentservice" {
  manifest = {
    "apiVersion" = "v1"
    "kind" = "Service"
    "metadata" = {
      "name" = "paymentservice"
      "namespace" = "demo-app"
    }
    "spec" = {
      "ports" = [
        {
          "name" = "grpc"
          "port" = 50051
          "targetPort" = 50051
          "protocol" = "TCP"
        },
      ]
      "selector" = {
        "app" = "paymentservice"
      }
      "type" = "ClusterIP"
    }
  }
}

resource "kubernetes_manifest" "deployment_productcatalogservice" {
  manifest = {
    "apiVersion" = "apps/v1"
    "kind" = "Deployment"
    "metadata" = {
      "name" = "productcatalogservice"
      "namespace" = "demo-app"
    }
    "spec" = {
      "selector" = {
        "matchLabels" = {
          "app" = "productcatalogservice"
        }
      }
      "template" = {
        "metadata" = {
          "labels" = {
            "app" = "productcatalogservice"
          }
        }
        "spec" = {
          "containers" = [
            {
              "env" = [
                {
                  "name" = "PORT"
                  "value" = "3550"
                },
              ]
              "image" = "gcr.io/google-samples/microservices-demo/productcatalogservice:v0.2.4"
              "livenessProbe" = {
                "exec" = {
                  "command" = [
                    "/bin/grpc_health_probe",
                    "-addr=:3550",
                  ]
                }
              }
              "name" = "server"
              "ports" = [
                {
                  "containerPort" = 3550
                  "protocol" = "TCP"
                },
              ]
              "readinessProbe" = {
                "exec" = {
                  "command" = [
                    "/bin/grpc_health_probe",
                    "-addr=:3550",
                  ]
                }
              }
              "resources" = {
                "limits" = {
                  "cpu" = "200m"
                  "memory" = "128Mi"
                }
                "requests" = {
                  "cpu" = "100m"
                  "memory" = "64Mi"
                }
              }
            },
          ]
          "serviceAccountName" = "default"
          "terminationGracePeriodSeconds" = 5
        }
      }
    }
  }
}

resource "kubernetes_manifest" "service_productcatalogservice" {
  manifest = {
    "apiVersion" = "v1"
    "kind" = "Service"
    "metadata" = {
      "name" = "productcatalogservice"
      "namespace" = "demo-app"
    }
    "spec" = {
      "ports" = [
        {
          "name" = "grpc"
          "port" = 3550
          "targetPort" = 3550
          "protocol" = "TCP"
        },
      ]
      "selector" = {
        "app" = "productcatalogservice"
      }
      "type" = "ClusterIP"
    }
  }
}

resource "kubernetes_manifest" "deployment_cartservice" {
  manifest = {
    "apiVersion" = "apps/v1"
    "kind" = "Deployment"
    "metadata" = {
      "name" = "cartservice"
      "namespace" = "demo-app"
    }
    "spec" = {
      "selector" = {
        "matchLabels" = {
          "app" = "cartservice"
        }
      }
      "template" = {
        "metadata" = {
          "labels" = {
            "app" = "cartservice"
          }
        }
        "spec" = {
          "containers" = [
            {
              "env" = [
                {
                  "name" = "REDIS_ADDR"
                  "value" = "redis-cart:6379"
                },
              ]
              "image" = "gcr.io/google-samples/microservices-demo/cartservice:v0.2.4"
              "livenessProbe" = {
                "exec" = {
                  "command" = [
                    "/bin/grpc_health_probe",
                    "-addr=:7070",
                    "-rpc-timeout=5s",
                  ]
                }
                "initialDelaySeconds" = 15
                "periodSeconds" = 10
              }
              "name" = "server"
              "ports" = [
                {
                  "containerPort" = 7070
                  "protocol" = "TCP"
                },
              ]
              "readinessProbe" = {
                "exec" = {
                  "command" = [
                    "/bin/grpc_health_probe",
                    "-addr=:7070",
                    "-rpc-timeout=5s",
                  ]
                }
                "initialDelaySeconds" = 15
              }
              "resources" = {
                "limits" = {
                  "cpu" = "300m"
                  "memory" = "128Mi"
                }
                "requests" = {
                  "cpu" = "200m"
                  "memory" = "64Mi"
                }
              }
            },
          ]
          "serviceAccountName" = "default"
          "terminationGracePeriodSeconds" = 5
        }
      }
    }
  }
}

resource "kubernetes_manifest" "service_cartservice" {
  manifest = {
    "apiVersion" = "v1"
    "kind" = "Service"
    "metadata" = {
      "name" = "cartservice"
      "namespace" = "demo-app"
    }
    "spec" = {
      "ports" = [
        {
          "name" = "grpc"
          "port" = 7070
          "targetPort" = 7070
          "protocol" = "TCP"
        },
      ]
      "selector" = {
        "app" = "cartservice"
      }
      "type" = "ClusterIP"
    }
  }
}

# resource "kubernetes_manifest" "deployment_loadgenerator" {
#   manifest = {
#     "apiVersion" = "apps/v1"
#     "kind" = "Deployment"
#     "metadata" = {
#       "name" = "loadgenerator"
#     }
#     "spec" = {
#       "replicas" = 1
#       "selector" = {
#         "matchLabels" = {
#           "app" = "loadgenerator"
#         }
#       }
#       "template" = {
#         "metadata" = {
#           "annotations" = {
#             "sidecar.istio.io/rewriteAppHTTPProbers" = "true"
#           }
#           "labels" = {
#             "app" = "loadgenerator"
#           }
#         }
#         "spec" = {
#           "containers" = [
#             {
#               "env" = [
#                 {
#                   "name" = "FRONTEND_ADDR"
#                   "value" = "frontend:80"
#                 },
#                 {
#                   "name" = "USERS"
#                   "value" = "10"
#                 },
#               ]
#               "image" = "gcr.io/google-samples/microservices-demo/loadgenerator:v0.2.4"
#               "name" = "main"
#               "resources" = {
#                 "limits" = {
#                   "cpu" = "500m"
#                   "memory" = "512Mi"
#                 }
#                 "requests" = {
#                   "cpu" = "300m"
#                   "memory" = "256Mi"
#                 }
#               }
#             },
#           ]
#           "initContainers" = [
#             {
#               "command" = [
#                 "/bin/sh",
#                 "-exc",
#                 <<EOT
#                 echo "Init container pinging frontend: ${FRONTEND_ADDR}..."
#                 STATUSCODE=$(wget --server-response http://${FRONTEND_ADDR} 2>&1 | awk '/^  HTTP/{print $2}')
#                 if test $STATUSCODE -ne 200; then
#                     echo "Error: Could not reach frontend - Status code: ${STATUSCODE}"
#                     exit 1
#                 fi
#                 EOT,
#               ]
#               "env" = [
#                 {
#                   "name" = "FRONTEND_ADDR"
#                   "value" = "frontend:80"
#                 },
#               ]
#               "image" = "busybox:latest"
#               "name" = "frontend-check"
#             },
#           ]
#           "restartPolicy" = "Always"
#           "serviceAccountName" = "default"
#           "terminationGracePeriodSeconds" = 5
#         }
#       }
#     }
#   }
#  }
# }

            

resource "kubernetes_manifest" "deployment_currencyservice" {
  manifest = {
    "apiVersion" = "apps/v1"
    "kind" = "Deployment"
    "metadata" = {
      "name" = "currencyservice"
      "namespace" = "demo-app"
    }
    "spec" = {
      "selector" = {
        "matchLabels" = {
          "app" = "currencyservice"
        }
      }
      "template" = {
        "metadata" = {
          "labels" = {
            "app" = "currencyservice"
          }
        }
        "spec" = {
          "containers" = [
            {
              "env" = [
                {
                  "name" = "PORT"
                  "value" = "7000"
                },
              ]
              "image" = "gcr.io/google-samples/microservices-demo/currencyservice:v0.2.4"
              "livenessProbe" = {
                "exec" = {
                  "command" = [
                    "/bin/grpc_health_probe",
                    "-addr=:7000",
                  ]
                }
              }
              "name" = "server"
              "ports" = [
                {
                  "containerPort" = 7000
                  "name" = "grpc"
                  "protocol" = "TCP"
                },
              ]
              "readinessProbe" = {
                "exec" = {
                  "command" = [
                    "/bin/grpc_health_probe",
                    "-addr=:7000",
                  ]
                }
              }
              "resources" = {
                "limits" = {
                  "cpu" = "200m"
                  "memory" = "128Mi"
                }
                "requests" = {
                  "cpu" = "100m"
                  "memory" = "64Mi"
                }
              }
            },
          ]
          "serviceAccountName" = "default"
          "terminationGracePeriodSeconds" = 5
        }
      }
    }
  }
}

resource "kubernetes_manifest" "service_currencyservice" {
  manifest = {
    "apiVersion" = "v1"
    "kind" = "Service"
    "metadata" = {
      "name" = "currencyservice"
      "namespace" = "demo-app"
    }
    "spec" = {
      "ports" = [
        {
          "name" = "grpc"
          "port" = 7000
          "targetPort" = 7000
          "protocol" = "TCP"
        },
      ]
      "selector" = {
        "app" = "currencyservice"
      }
      "type" = "ClusterIP"
    }
  }
}

resource "kubernetes_manifest" "deployment_shippingservice" {
  manifest = {
    "apiVersion" = "apps/v1"
    "kind" = "Deployment"
    "metadata" = {
      "name" = "shippingservice"
      "namespace" = "demo-app"
    }
    "spec" = {
      "selector" = {
        "matchLabels" = {
          "app" = "shippingservice"
        }
      }
      "template" = {
        "metadata" = {
          "labels" = {
            "app" = "shippingservice"
          }
        }
        "spec" = {
          "containers" = [
            {
              "env" = [
                {
                  "name" = "PORT"
                  "value" = "50051"
                },
              ]
              "image" = "gcr.io/google-samples/microservices-demo/shippingservice:v0.2.4"
              "livenessProbe" = {
                "exec" = {
                  "command" = [
                    "/bin/grpc_health_probe",
                    "-addr=:50051",
                  ]
                }
              }
              "name" = "server"
              "ports" = [
                {
                  "containerPort" = 50051
                  "protocol" = "TCP"
                },
              ]
              "readinessProbe" = {
                "exec" = {
                  "command" = [
                    "/bin/grpc_health_probe",
                    "-addr=:50051",
                  ]
                }
                "periodSeconds" = 5
              }
              "resources" = {
                "limits" = {
                  "cpu" = "200m"
                  "memory" = "128Mi"
                }
                "requests" = {
                  "cpu" = "100m"
                  "memory" = "64Mi"
                }
              }
            },
          ]
          "serviceAccountName" = "default"
        }
      }
    }
  }
}

resource "kubernetes_manifest" "service_shippingservice" {
  manifest = {
    "apiVersion" = "v1"
    "kind" = "Service"
    "metadata" = {
      "name" = "shippingservice"
      "namespace" = "demo-app"
    }
    "spec" = {
      "ports" = [
        {
          "name" = "grpc"
          "port" = 50051
          "targetPort" = 50051
          "protocol" = "TCP"
        },
      ]
      "selector" = {
        "app" = "shippingservice"
      }
      "type" = "ClusterIP"
    }
  }
}

resource "kubernetes_manifest" "deployment_redis_cart" {
  manifest = {
    "apiVersion" = "apps/v1"
    "kind" = "Deployment"
    "metadata" = {
      "name" = "redis-cart"
      "namespace" = "demo-app"
    }
    "spec" = {
      "selector" = {
        "matchLabels" = {
          "app" = "redis-cart"
        }
      }
      "template" = {
        "metadata" = {
          "labels" = {
            "app" = "redis-cart"
          }
        }
        "spec" = {
          "containers" = [
            {
              "image" = "redis:alpine"
              "livenessProbe" = {
                "periodSeconds" = 5
                "tcpSocket" = {
                  "port" = 6379
                }
              }
              "name" = "redis"
              "ports" = [
                {
                  "containerPort" = 6379
                  "protocol" = "TCP"
                },
              ]
              "readinessProbe" = {
                "periodSeconds" = 5
                "tcpSocket" = {
                  "port" = 6379
                }
              }
              "resources" = {
                "limits" = {
                  "cpu" = "125m"
                  "memory" = "256Mi"
                }
                "requests" = {
                  "cpu" = "70m"
                  "memory" = "200Mi"
                }
              }
              "volumeMounts" = [
                {
                  "mountPath" = "/data"
                  "name" = "redis-data"
                },
              ]
            },
          ]
          "volumes" = [
            {
              "emptyDir" = {}
              "name" = "redis-data"
            },
          ]
        }
      }
    }
  }
}

resource "kubernetes_manifest" "service_redis_cart" {
  manifest = {
    "apiVersion" = "v1"
    "kind" = "Service"
    "metadata" = {
      "name" = "redis-cart"
      "namespace" = "demo-app"
    }
    "spec" = {
      "ports" = [
        {
          "name" = "redis"
          "port" = 6379
          "targetPort" = 6379
          "protocol" = "TCP"
        },
      ]
      "selector" = {
        "app" = "redis-cart"
      }
      "type" = "ClusterIP"
    }
  }
}

resource "kubernetes_manifest" "deployment_adservice" {
  manifest = {
    "apiVersion" = "apps/v1"
    "kind" = "Deployment"
    "metadata" = {
      "name" = "adservice"
      "namespace" = "demo-app"
    }
    "spec" = {
      "selector" = {
        "matchLabels" = {
          "app" = "adservice"
        }
      }
      "template" = {
        "metadata" = {
          "labels" = {
            "app" = "adservice"
          }
        }
        "spec" = {
          "containers" = [
            {
              "env" = [
                {
                  "name" = "PORT"
                  "value" = "9555"
                },
              ]
              "image" = "gcr.io/google-samples/microservices-demo/adservice:v0.2.4"
              "livenessProbe" = {
                "exec" = {
                  "command" = [
                    "/bin/grpc_health_probe",
                    "-addr=:9555",
                  ]
                }
                "initialDelaySeconds" = 20
                "periodSeconds" = 15
              }
              "name" = "server"
              "ports" = [
                {
                  "containerPort" = 9555
                  "protocol" = "TCP"
                },
              ]
              "readinessProbe" = {
                "exec" = {
                  "command" = [
                    "/bin/grpc_health_probe",
                    "-addr=:9555",
                  ]
                }
                "initialDelaySeconds" = 20
                "periodSeconds" = 15
              }
              "resources" = {
                "limits" = {
                  "cpu" = "300m"
                  "memory" = "300Mi"
                }
                "requests" = {
                  "cpu" = "200m"
                  "memory" = "180Mi"
                }
              }
            },
          ]
          "serviceAccountName" = "default"
          "terminationGracePeriodSeconds" = 5
        }
      }
    }
  }
}

resource "kubernetes_manifest" "service_adservice" {
  manifest = {
    "apiVersion" = "v1"
    "kind" = "Service"
    "metadata" = {
      "name" = "adservice"
      "namespace" = "demo-app"
    }
    "spec" = {
      "ports" = [
        {
          "name" = "grpc"
          "port" = 9555
          "targetPort" = 9555
          "protocol" = "TCP"
        },
      ]
      "selector" = {
        "app" = "adservice"
      }
      "type" = "ClusterIP"
    }
  }
}


  
  