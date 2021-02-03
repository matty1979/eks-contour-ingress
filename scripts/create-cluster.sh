#!/usr/bin/env bash
set -e

if [[ ! -x "$(command -v eksctl)" ]]; then
    echo "eksctl not found"
    exit 1
fi

cat << EOF | eksctl create cluster -f -
apiVersion: eksctl.io/v1alpha5
kind: ClusterConfig
metadata:
  name: octo-speed
  region: us-west-2
nodeGroups:
  - name: controllers
    #labels: 
      #role: controllers
    instanceType: m5.xlarge
    desiredCapacity: 3
    minSize: 3
    maxSize: 6
    privateNetworking: true
    #labels: 
      #role: worker
    tags:
      nodegroup-role: worker
      environment: dev
      bu: coe-ai
    iam:
      withAddonPolicies:
        certManager: true
        albIngress: true
        cloudWatch: true
        externalDNS: true
        imageBuilder: true
    taints:
      controllers: "true:NoSchedule"
    ssh: 
      allow: true
      publicKeyPath: eksctl-key.pub
managedNodeGroups:
  - name: workers
    #labels: 
      #role: workers
    instanceType: m5.large
    desiredCapacity: 3
    minSize: 3
    maxSize: 6
    privateNetworking: true
    #labels: 
      #role: worker
    tags:
      nodegroup-role: worker
      environment: dev
      bu: coe-ai
    ssh: 
      allow: true
      publicKeyPath: eksctl-key.pub
    volumeSize: 120
EOF

