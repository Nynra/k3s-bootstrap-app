apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: kub-dashboard
  namespace: {{ .Values.global.argocdConfig.namespace }}
  finalizers:
    - resources-finalizer.argocd.argoproj.io
  annotations:
    argocd.argoproj.io/sync-wave: "2"
spec:
  project: {{ .Values.project }}
  source:
      repoURL: https://kubernetes.github.io/dashboard/
      chart: kubernetes-dashboard
      targetRevision: {{ .Values.kubDashboard.targetRevision }}
  destination:
    server: {{ .Values.global.argocdConfig.server }}
    namespace: {{ .Values.kubDashboard.namespace }}
  syncPolicy:
    automated:
      selfHeal: true
      prune: true
    syncOptions:
      - CreateNamespace=true
