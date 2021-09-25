module "ecr" {
  source  = "Young-ook/eks/aws//modules/ecr"
  name    = "container-registry-eks"
}
