apiVersion: traefik.io/v1alpha1
kind: TraefikService
metadata:
  name: lan-only-ref
  namespace: {{ .Values.kubDashboard.namespace }}
  annotations:
    argocd.argoproj.io/sync-wave: "1"
spec:
  mirroring:
    name: lan-only
    namespace: {{ .Values.traefik.namespace }}