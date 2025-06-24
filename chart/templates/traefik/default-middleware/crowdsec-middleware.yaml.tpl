apiVersion: traefik.io/v1alpha1
kind: Middleware
metadata:
  name: crowdsec-bouncer
  namespace: {{ .Values.traefik.namespace }}
  annotations:
    argocd.argoproj.io/sync-wave: "-8"
spec:
  plugin:
    crowdsec-bouncer:
      enabled: true