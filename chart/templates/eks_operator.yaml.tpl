apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: cluster-secrets-operator
  namespace: {{ .Values.global.argocdConfig.namespace }}
  annotations:
    argocd.argoproj.io/sync-wave: "1"
spec:
  destination:
    namespace: {{ .Values.eks.onepasswordOperator.namespace }}
    server: {{ .Values.global.argocdConfig.server }}
  project: {{ .Values.project }}
  source:
    repoURL: https://charts.external-secrets.io
    targetRevision: {{ .Values.eks.onepasswordOperator.targetRevision }}
    chart: external-secrets
    helm:
      values: |-
        crds:
          createClusterExternalSecret: true
          createClusterSecretStore: true
          createClusterGenerator: true
          createClusterPushSecret: true
          createPushSecret: true
        # -- If set external secrets are only reconciled in the
        # provided namespace
        scopedNamespace: ""
        # -- Must be used with scopedNamespace. If true, create scoped RBAC roles under the scoped namespace
        # and implicitly disable cluster stores and cluster external secrets
        scopedRBAC: false
        # -- if true, the operator will process cluster external secret. Else, it will ignore them.
        processClusterExternalSecret: true
        # -- if true, the operator will process cluster push secret. Else, it will ignore them.
        processClusterPushSecret: true
        # -- if true, the operator will process cluster store. Else, it will ignore them.
        processClusterStore: true
        # -- if true, the operator will process push secret. Else, it will ignore them.
        processPushSecret: true
        grafanaDashboard:
          # -- If true creates a Grafana dashboard.
          enabled: false
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
      - CreateNamespace=true
