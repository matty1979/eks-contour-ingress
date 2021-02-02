#!/usr/bin/env bash
set -e

if [[ ! -x "$(command -v eksctl)" ]]; then
    echo "eksctl not found"
    exit 1
fi

cat << EOF | eksctl create cluster -f -
# apiVersion: eksctl.io/v1alpha5
# kind: ClusterConfig
# metadata:
#   name: my-cluster
#   region: eu-west-1
# nodeGroups:
#   - name: controllers
#     labels: { role: controllers }
#     instanceType: m5.large
#     desiredCapacity: 2
#     iam:
#       withAddonPolicies:
#         certManager: true
#         albIngress: true
#     taints:
#       controllers: "true:NoSchedule"
# managedNodeGroups:
#   - name: workers
#     labels: { role: workers }
#     instanceType: m5.large
#     desiredCapacity: 2
#     volumeSize: 120
apiVersion: eksctl.io/v1alpha5
kind: ClusterConfig

#metadata is what defines naming and placement of cluster
metadata:
  name: speed-cluster
  region: us-west-2
  version: "1.18"
availabilityZones: ['us-west-2a', 'us-west-2b', 'us-west-2c']
#Set Cluster Size Here paying attention to Instance Type and min/max settings
managedNodeGroups:
  - name: managed-ng-1
    instanceType: m5.xlarge
    desiredCapacity: 3
    minSize: 3
    maxSize: 6
    privateNetworking: true
    labels: {role: worker}
    tags:
      nodegroup-role: worker
      environment: dev
      bu: coe-ai
    iam:
      withAddonPolicies:
        externalDNS: true
        certManager: true
        imageBuilder: true 
        albIngress: true
        cloudWatch: true
    ssh:
      allow: true
      publicKeyPath: eksctl-key.pub #I copied to running directory will put detailed instructions on how to generate in README.md
cloudWatch:
  clusterLogging:
    enableTypes: ['*']
EOF

