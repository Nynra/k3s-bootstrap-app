# app-1password-connect.yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: 1password-app
  namespace: {{ .Values.argoConfig.namespace }}
  finalizers:
    - resources-finalizer.argocd.argoproj.io
  annotations:
    argocd.argoproj.io/sync-wave: "-10"
spec:
  destination:
    namespace: {{ .Values.passwordApp.namespace }}
    server: {{ .Values.argoConfig.server }}
  project: {{ .Values.project }}
  source:
    repoURL: https://gitlab.structam.nl/homelab/k8/core/eks-1password.git
    path: chart
    targetRevision: {{ .Values.passwordApp.targetRevision }}
    helm:
      values: |
        project: {{ .Values.project }}
        argoConfig:
          project: {{ .Values.argoConfig.project }}
          server: {{ .Values.argoConfig.server }}
          namespace: {{ .Values.argoConfig.namespace }}
        onepasswordOperator:
          namespace: {{ .Values.passwordApp.onepasswordOperator.namespace }}
          targetRevision: {{ .Values.passwordApp.onepasswordOperator.targetRevision }}
        onepasswordConnect:
          namespace: {{ .Values.passwordApp.onepasswordConnect.namespace }}
          targetRevision: {{ .Values.passwordApp.onepasswordConnect.targetRevision }}
  syncPolicy:
    automated: 
      prune: true
      selfHeal: true
    syncOptions:
      - CreateNamespace=true
