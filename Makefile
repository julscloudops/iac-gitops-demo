# .PHONY: install-argocd get-argocd-password check-argocd-ready proxy-argocd-ui 

list:
	@$(MAKE) -pRrq -f $(lastword $(MAKEFILE_LIST)) : 2>/dev/null | awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | sort | egrep -v -e '^[^[:alnum:]]' -e '^$@$$'

install-argocd:
	kubectl create ns argocd || true
	helm repo add bitnami https://charts.bitnami.com/bitnami 
	helm install --namespace argocd argo-cd bitnami/argo-cd 

check-argocd-ready:
	kubectl wait --for=condition=available deployment -l "app.kubernetes.io/name=argo-cd" -n argocd --timeout=300s

# It is required to login into ArgoCD CLI to be able to deploy the applications
proxy-argocd:
	kubectl port-forward --namespace argocd svc/argo-cd-server 8080:80 &
	argocd login localhost:8080

install-demo-app:
	argocd repo add https://github.com/julscloudops/ManifestsForArgoCD
	kubectl create namespace demo-app || true
	argocd app create demo-app \
	--repo https://github.com/julscloudops/ManifestsForArgoCD \
	--path app \
	--dest-namespace demo-app \
	--dest-server https://kubernetes.default.svc 
	argocd app sync demo-app

install-prometheus:
	kubectl create namespace monitoring || true
	argocd app create prometheus \
	--repo https://github.com/julscloudops/ManifestsForArgoCD \
	--path charts/kube-prometheus --dest-namespace monitoring \
	--dest-server https://kubernetes.default.svc 
	argocd app sync prometheus

install-grafana:
	argocd app create grafana \
	--repo https://github.com/julscloudops/ManifestsForArgoCD \
	--path charts/grafana --dest-namespace monitoring \
	--dest-server https://kubernetes.default.svc 
	argocd app sync grafana

install-ingress-nginx:
	kubectl create namespace ingress-nginx || true
	argocd app create ingress-nginx \
	--repo https://github.com/julscloudops/ManifestsForArgoCD \
	--path charts/nginx-ingress-controller --dest-namespace ingress-nginx \
	--dest-server https://kubernetes.default.svc 
	argocd app sync ingress-nginx

install-cert-manager:
	kubectl create namespace cert-manager || true
	argocd app create cert-manager \
	--repo https://github.com/julscloudops/ManifestsForArgoCD \
	--path charts/cert-manager --dest-namespace cert-manager \
	--dest-server https://kubernetes.default.svc 
	argocd app sync cert-manager
	kubectl apply -f app-layer/ssl-setup/cert-issuer-nginx-ingress.yaml

install fluentd:
	kubectl create namespace fluentd || true
	argocd app create fluentd \
	--repo https://github.com/julscloudops/ManifestsForArgoCD \
	--path charts/fluentd --dest-namespace fluentd \
	--dest-server https://kubernetes.default.svc 

	argocd app sync fluentd
	
install-velero:
	kubectl create namespace velero || true
	argocd app create velero \
	--repo https://github.com/julscloudops/ManifestsForArgoCD \
	--path charts/velero --dest-namespace velero \
	--dest-server https://kubernetes.default.svc 

	argocd app sync velero
	
cleanup:
	helm delete argocd || true
	kubectl delete appprojects.argoproj.io --all
	kubectl delete applications.argoproj.io --all
	kubectl delete ns argocd
	kubectl delete ns demo-app
	kubectl delete ns monitoring
	kubectl delete ns ingress-nginx
	kubectl delete ns cert-manager
	kubectl delete ns fluentd
	# kubectl delete ns velero
