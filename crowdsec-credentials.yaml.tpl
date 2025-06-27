apiVersion: external-secrets.io/v1
kind: ExternalSecret
metadata:
  name: crowdsec-credentials
  namespace: {{ .Values.crowdsec.namespace }}
  annotations:
    argocd.argoproj.io/sync-wave: "5"
spec:
  secretStoreRef:
    kind: ClusterSecretStore
    name: {{ .Values.crowdsec.externalSecret.remoteSecretStore }}
  target:
    creationPolicy: Owner
    template:
      data:
        csLapiSecretKey: "{{ .csLapiSecretKey}}"
        registrationToken: "{{ .registrationToken }}"
  data:
    - secretKey: csLapiSecretKey
      remoteRef:
        key: {{ .Values.crowdsec.externalSecret.remoteSecretName }}
        property: {{ .Values.crowdsec.externalSecret.csLapiSecretPropertyName }}
    - secretKey: registrationToken
      remoteRef:
        key: {{ .Values.crowdsec.externalSecret.remoteSecretName }}
        property: {{ .Values.crowdsec.externalSecret.registrationTokenPropertyName }}