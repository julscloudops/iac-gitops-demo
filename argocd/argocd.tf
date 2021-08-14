module "argo_cd" {
  source = "runoncloud/argocd/kubernetes"
  namespace       = "argocd"
  argo_cd_version = "1.8.7"
}

