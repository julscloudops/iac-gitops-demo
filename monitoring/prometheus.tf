module "release-prometheus-operator" {
  source  = "OpenQAI/release-prometheus-operator/helm"
  version = "0.0.6"

  defaultRules_create    = false
  helm_chart_version     = "8.15.11"
  helm_chart_namespace   = "monitoring"
  skip_crds              =  false
  grafana_adminPassword  = "pa$$w0rd"

}
