{{- range .Values.certManager.certs }}
---
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: {{ .commonName | replace "." "-" }}-cert
  namespace: {{ .namespace }}
  annotations:
    argocd.argoproj.io/sync-wave: "-17"
spec:
  secretName: {{ .secretName }}
  commonName: {{ .commonName }}
  dnsNames:
    {{- range .dnsNames }}
    - "{{ . }}"
    {{- end }}
  issuerRef:
    name: {{ .clusterIssuer }}
    kind: ClusterIssuer
{{- end }}