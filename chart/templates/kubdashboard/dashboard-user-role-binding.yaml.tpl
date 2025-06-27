apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: dashboard-user
  annotations:
    argocd.argoproj.io/sync-wave: "31"
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: dashboard-view-only
subjects:
- kind: ServiceAccount
  name: dashboard-user
  namespace: {{ .Values.kubDashboard.namespace }}