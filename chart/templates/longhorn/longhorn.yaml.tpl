apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: longhorn-app
  namespace: {{ .Values.global.argocdConfig.namespace }}
  finalizers:
    - resources-finalizer.argocd.argoproj.io
  annotations:
    argocd.argoproj.io/sync-wave: "27"
spec:
  project: {{ .Values.project }}
  sources:
    - chart: longhorn
      repoURL: https://charts.longhorn.io/
      targetRevision: {{ .Values.longhorn.targetRevision }}
      helm:
        values: |
          preUpgradeChecker:
            jobEnabled: {{ .Values.longhorn.preUpgradeCheckerJobEnabled }}
          persistence:
            defaultClass: {{ .Values.longhorn.defaultStorageClass }}
            defaultClassReplicaCount: {{ .Values.longhorn.defaultStorageReplicaCount }}
            migratable: {{ .Values.longhorn.defaultMigratable }}
          # (Options: "NFS", "CIFS", "AWS", "GCP", "AZURE")
          # defaultBackupStore:
          #   backupTarget: {{ .Values.longhorn.defaultBackupTarget }}
          #   backupTargetCredentialSecret: {{ .Values.longhorn.defaultBackupTargetCredentialSecret }}
          longhornUI:
            replicas: {{ .Values.longhorn.dashboard.replicaCount }}
          service:
            ui:
              type: {{ .Values.longhorn.dashboard.serviceType }}

  destination:
    server: {{ .Values.global.argocdConfig.server }}
    namespace: {{ .Values.longhorn.namespace }}
  syncPolicy:
    automated:
      # prune: true
      # selfHeal: true
    syncOptions:
      - CreateNamespace=true
    # ignoreDifferences:
    #   - group: apiextensions.k8s.io
    #     name: volumes.longhorn.io
    #     kind: CustomResourceDefinition
    #     jsonPointers:
    #       - /spec/preserveUnknownFields
