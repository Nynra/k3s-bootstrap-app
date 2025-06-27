apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: external-secrets-operator
  namespace: {{ .Values.global.argocdConfig.namespace }}
  annotations:
    argocd.argoproj.io/sync-wave: "1"
spec:
  destination:
    namespace: {{ .Values.eks.onepasswordOperator.namespace }}
    server: {{ .Values.global.argocdConfig.server }}
  project: {{ .Values.project }}
  source:
    repoURL: https://charts.external-secrets.io
    targetRevision: {{ .Values.eks.onepasswordOperator.targetRevision }}
    chart: external-secrets
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
      - CreateNamespace=true
