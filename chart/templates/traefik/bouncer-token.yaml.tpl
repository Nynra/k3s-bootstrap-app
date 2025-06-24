apiVersion: external-secrets.io/v1
kind: ExternalSecret
metadata:
  name: crowdsec-bouncer-token
  namespace: {{ .Values.traefik.namespace }}
  annotations:
    argocd.argoproj.io/sync-wave: "-25"
spec:
  secretStoreRef:
    kind: ClusterSecretStore
    name: {{ .Values.crowdsec.externalSecret.remoteSecretStore }}
  target:
    creationPolicy: Owner
  data:
    - secretKey: key
      remoteRef:
        key: {{ .Values.crowdsec.externalSecret.remoteSecretName }}
        property: {{ .Values.crowdsec.externalSecret.registrationTokenPropertyName }}