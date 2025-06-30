apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: kube-prometheus-stack-app
  namespace: {{ .Values.global.argocdConfig.namespace }}
  finalizers:
    - resources-finalizer.argocd.argoproj.io
  annotations:
    argocd.argoproj.io/sync-wave: "-5"
spec:
  project: {{ .Values.project }}
  destination:
    server: {{ .Values.global.argocdConfig.server }}
    namespace: {{ .Values.kubePrometheusStack.namespace }}
  source:
    repoURL: https://prometheus-community.github.io/helm-charts
    chart: kube-prometheus-stack
    targetRevision: {{ .Values.kubePrometheusStack.targetRevision }}
    helm:
      values: |
        grafana:
          defaultDashboardsTimezone: utc
          defaultDashboardsInterval: 1m
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
      - ServerSideApply=true  # Needed for large crds
      - CreateNamespace=true
