.PHONY: install-argocd get-argocd-password proxy-argocd-ui check-argocd-ready

list:
	@$(MAKE) -pRrq -f $(lastword $(MAKEFILE_LIST)) : 2>/dev/null | awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | sort | egrep -v -e '^[^[:alnum:]]' -e '^$@$$'

install-argocd:
	kubectl create ns argocd || true
	helm repo add bitnami https://charts.bitnami.com/bitnami 
    helm install --namespace argocd argo-cd bitnami/argo-cd 

get-argocd-password:
	# kubectl get pods -n argocd -l app.kubernetes.io/name=argocd-server -o name | cut -d'/' -f 2
    echo "Password: $(kubectl -n argocd get secret argocd-secret -o jsonpath="{.data.clearPassword}" | base64 -d)"

check-argocd-ready:
	kubectl wait --for=condition=available deployment -l "app.kubernetes.io/name=argocd-server" -n argocd --timeout=300s

proxy-argocd-ui:
	kubectl port-forward --namespace argocd svc/argo-cd-server 8080:80 &
	argocd login localhost:8080
	
install-demo-app:
	argocd repo add https://github.com/julscloudops/ManifestsForArgoCD
	kubectl create namespace demo-app
	argocd app create demo-app \
	--repo https://github.com/julscloudops/ManifestsForArgoCD \
	--path app \
	--dest-namespace demo-app \
	--dest-server https://kubernetes.default.svc 
	argocd app sync demo-app

install-prometheus:
	kubectl create namespace monitoring
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
	kubectl create namespace ingress-nginx
	argocd app create ingress-nginx \
	--repo https://github.com/julscloudops/ManifestsForArgoCD \
	--path charts/nginx-ingress-controller --dest-namespace ingress-nginx \
	--dest-server https://kubernetes.default.svc 
	argocd app sync ingress-nginx

install-cert-manager:
	kubectl create namespace cert-manager
    argocd app create cert-manager \
	--repo https://github.com/julscloudops/ManifestsForArgoCD \
	--path charts/cert-manager --dest-namespace cert-manager \
	--dest-server https://kubernetes.default.svc 
	argocd app sync cert-manager
	
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
