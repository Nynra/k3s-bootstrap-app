apiVersion: traefik.io/v1alpha1
kind: Middleware
metadata:
  name: redirect-to-https
  namespace: {{ .Values.traefik.namespace }}
  annotations:
    argocd.argoproj.io/sync-wave: "-7"
spec:
  redirectScheme:
    scheme: https
    permanent: true
