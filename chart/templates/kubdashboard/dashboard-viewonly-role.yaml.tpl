apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: dashboard-view-only
  annotations:
    argocd.argoproj.io/sync-wave: "30"
rules:
- apiGroups: ["", "apps", "autoscaling", "batch", "extensions", "policy", "rbac.authorization.k8s.io", "networking.k8s.io", "storage.k8s.io"]
  resources: ["*", "pods/log"]
  verbs: ["get", "list", "watch"]
- nonResourceURLs: ["*"]
  verbs: ["get"]