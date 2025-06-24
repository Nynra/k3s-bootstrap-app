# Bootstrap App

The bootstrap app provides the basic infrastructure needed to deploy services to a k3s cluster. It includes the following features:

- External Secrets Operator for managing secrets from external sources (1password)
- Cert-manager for managing SSL/TLS certificates
- Longhorn for managing persistent storage
- Crowdsec Bouncer for security and threat detection
- Traefik ingress controller for routing external traffic
- Kubernetes Dashboard for monitoring basic cluster health

## Prerequisites

The EKS expects 2 secrets to be created in the cluster manually:
<https://dev.to/3deep5me/using-1password-with-external-secrets-operator-in-a-gitops-way-4lo4>
create connect token and 1password credentials manually for now

During installation argocd validation has to be turned off as the app references custom resources that are not yet created.

## Sync Order

-30: external secrets operator
-30: reflector
-25: external secrets
-20: cert-manager
-15: crowdsec
-10: traefik
-5 : longhorn
 0 : dashboard
