apiVersion: v1
kind: ServiceAccount
metadata:
  name: dashboard-user
  namespace: {{ .Values.kubDashboard.namespace }}
  annotations:
    argocd.argoproj.io/sync-wave: "0"