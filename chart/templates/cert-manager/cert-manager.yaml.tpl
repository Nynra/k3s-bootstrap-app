apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: cert-manager
  namespace: {{ .Values.global.argocdConfig.namespace }}
  finalizers:
    - resources-finalizer.argocd.argoproj.io
  annotations:
    argocd.argoproj.io/sync-wave: "-20"
spec:
  project: {{ .Values.project }}
  destination:
    server: {{ .Values.global.argocdConfig.server }}
    namespace: {{ .Values.certManager.namespace }}
  source:
    repoURL: "https://charts.jetstack.io"
    chart: cert-manager
    targetRevision: {{ .Values.certManager.targetRevision }}
    helm:
      values: |
        crds:
          enabled: true
        replicaCount: {{ .Values.certManager.replicas }}
        extraArgs:
          - --dns01-recursive-nameservers=1.1.1.1:53,9.9.9.9:53
          - --dns01-recursive-nameservers-only
        podDnsPolicy: None
        podDnsConfig:
          nameservers:
            - 1.1.1.1
            - 9.9.9.9
  syncPolicy:
    automated:
      selfHeal: true
    syncOptions:
      - CreateNamespace=true
