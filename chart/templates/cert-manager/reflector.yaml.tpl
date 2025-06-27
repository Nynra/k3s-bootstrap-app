apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: reflector
  namespace: {{ .Values.global.argocdConfig.namespace }}
  finalizers:
    - resources-finalizer.argocd.argoproj.io
  annotations:
    argocd.argoproj.io/sync-wave: "-30"
spec:
  project: {{ .Values.project }}
  source:
    repoURL: https://emberstack.github.io/helm-charts
    chart: reflector
    targetRevision: {{ .Values.reflector.targetRevision }}
  destination:
    server: {{ .Values.global.argocdConfig.server }}
    namespace: {{ .Values.certManager.namespace }}
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
      - CreateNamespace=true
