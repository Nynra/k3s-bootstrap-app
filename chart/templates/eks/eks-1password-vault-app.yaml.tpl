apiVersion: external-secrets.io/v1
kind: ClusterSecretStore
metadata:
  name: {{ .Values.mainVault.name }}
  annotations:
    argocd.argoproj.io/sync-wave: "-28"
    # Cannot validate as the needed CRD is not installed yet
    argocd.argoproj.io/sync-options: Validate=false
spec:
  provider:
    onepassword:
      connectHost: http://onepassword-connect:8080
      vaults:
        {{ .Values.mainVault.vaultName }}: 1
      auth:
        secretRef:
          connectTokenSecretRef:
            name: {{ .Values.mainVault.connectTokenSecretName }}
            key: token
            namespace: {{ .Values.mainVault.connectTokenNamespace }}
  # destination:
  #   name: {{ .Values.global.argocdConfig.server }}
  #   namespace: {{ .Values.global.argocdConfig.namespace }}
