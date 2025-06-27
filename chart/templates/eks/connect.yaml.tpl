# app-1password-connect.yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: 1password-connect
  namespace: {{ .Values.global.argocdConfig.namespace }}
  annotations:
    argocd.argoproj.io/sync-wave: "0"
spec:
  destination:
    namespace: {{ .Values.eks.onepasswordConnect.namespace }}
    server: {{ .Values.global.argocdConfig.server }}
  project: {{ .Values.project }}
  source:
    repoURL: https://1password.github.io/connect-helm-charts
    targetRevision: {{ .Values.eks.onepasswordConnect.targetRevision }}
    chart: connect
    helm:
      values: |
        connect:
          serviceType: ClusterIP
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
      - CreateNamespace=true
