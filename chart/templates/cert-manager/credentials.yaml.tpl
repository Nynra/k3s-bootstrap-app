{{- range .Values.certManager.issuers }}
---
apiVersion: external-secrets.io/v1
kind: ExternalSecret
metadata:
  name: {{ .externalSecret.name }}
  # Argocd cannot add secrets to the default namespace but issuers look
  # in the cert-manager namespace automatically
  namespace: {{ .namespace }}
  annotations:
    argocd.argoproj.io/sync-wave: "5"
spec:
  secretStoreRef:
    kind: ClusterSecretStore
    name: {{ .externalSecret.remoteSecretStore }}
  target:
    creationPolicy: Owner
  data:
    - secretKey: token
      remoteRef:
        key: {{ .externalSecret.remoteSecretName | quote }}
        property: {{ .externalSecret.tokenPropertyName }}
{{- end }}