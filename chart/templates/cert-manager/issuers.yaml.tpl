{{- range .Values.certManager.issuers }}
---
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: {{ .name }}
  annotations:
    argocd.argoproj.io/sync-wave: "12"
spec:
  acme:
    server: {{ .server }}
    email: {{ .email }}
    privateKeySecretRef:
      name: {{ .externalSecret.name }}
      key: token
    solvers:
      - dns01:
          cloudflare:
            apiTokenSecretRef:
              name: {{ .externalSecret.name }}
              key: token
        selector:
          dnsZones:
          {{- range .domains }}
          - "{{ . }}"
          {{- end }} 
{{- end }}