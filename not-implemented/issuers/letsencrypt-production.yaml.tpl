apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-production
  annotations:
    argocd.argoproj.io/sync-wave: "0"
spec:
  acme:
    server: https://acme-v02.api.letsencrypt.org/directory
    email: {{ .Values.certManager.issuers.cloudflareCredentials.email }}
    privateKeySecretRef:
      name: {{ .Values.certManager.issuers.productionPrivateKeySecretName }}
    solvers:
      - dns01:
          cloudflare:
            apiTokenSecretRef:
              name: {{ .Values.certManager.issuers.cloudflareCredentials.secretName }}
              key: {{ .Values.certManager.issuers.cloudflareCredentials.secretKey }}
        selector:
          dnsZones:
          {{- range .Values.certManager.domains }}
          - "{{ . }}"
          {{- end }}
