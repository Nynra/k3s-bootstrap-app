apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: traefik-default-middleware-app
  namespace: {{ .Values.argoConfig.namespace }}
  finalizers:
    - resources-finalizer.argocd.argoproj.io
  annotations:
    argocd.argoproj.io/sync-wave: "-7"
spec:
  project: {{ .Values.project }}
  source:
    repoURL: https://gitlab.structam.nl/homelab/k8/core/traefik-cert-manager.git
    path: charts/traefik-default-middleware
    targetRevision: {{ .Values.traefikDefaultMiddlewareApp.targetRevision }}
    helm:
      values: |
        argoConfig:
          project: {{ .Values.argoConfig.project }}
          server: {{ .Values.argoConfig.server }}
          namespace: {{ .Values.argoConfig.namespace }}
        global:
          namespace: {{ .Values.traefikDefaultMiddlewareApp.global.namespace }}
        localOnlyAllowlist:
          localIps: {{ .Values.traefikDefaultMiddlewareApp.localOnlyAllowlist.localIps }}
  destination:
    server: {{ .Values.argoConfig.server }}
    namespace: {{ .Values.traefikDefaultMiddlewareApp.namespace }}
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
      - CreateNamespace=true
