#!/usr/bin/env bash
set -e

if [[ ! -x "$(command -v fluxctl)" ]]; then
    echo "fluxctl not found"
    exit 1
fi

read -p "Enter GitHub username (not email) with access to repo: " GHUSER

kubectl create ns fluxcd
export GHUSER=$GHUSER  
fluxctl install \
--git-user=${GHUSER} \
--git-email=${GHUSER}@users.noreply.github.com \
--git-url=git@github.com:${GHUSER}/eks-contour-ingress \
--git-branch=master \
--manifest-generation=true \
--namespace=fluxcd | kubectl apply -f -

#Setup Git Sync 
#At startup, Flux generates a SSH key and logs the public key. Find the public key with:
fluxctl identity --k8s-fwd-ns fluxcd

#Export this key and on repo add to settings ~> Deployment Keys
#Flux will now add contour and cert-manager pods this can take some time 

#Configure DNS 
#Retrive external DNS of Envoy LB
kubectl get -n projectcontour service envoy -o wide