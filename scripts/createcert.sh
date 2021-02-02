export GHUSER="matty1979" && \
cat << EOF | tee ingress/issuer.yaml
apiVersion: cert-manager.io/v1alpha2
kind: ClusterIssuer
metadata:
  name: letsencrypt-prod
  annotations:
    fluxcd.io/ignore: "false"
spec:
  acme:
    email: ${GHUSER}@users.noreply.github.com
    privateKeySecretRef:
      name: letsencrypt-prod
    server: https://acme-v02.api.letsencrypt.org/directory
    solvers:
    - dns01:
        route53:
          region: us-west-2
EOF