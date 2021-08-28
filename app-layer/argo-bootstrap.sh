#!/usr/bin/env bash

install_argo_cd () {
    echo "Installing Argo CD ..."
    kubectl create namespace argo
    kubectl apply -n argo \
        -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

    echo "Configuring repo with the manifests ..."
    kubectl apply -f argo-apps.yaml
}
