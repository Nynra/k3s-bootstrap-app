apiVersion: traefik.io/v1alpha1
kind: Middleware
metadata:
  name: lan-only
  namespace: {{ .Values.traefik.namespace }}
  annotations:
    argocd.argoproj.io/sync-wave: "-7"
spec:
  ipWhiteList:
    sourceRange:
      {{- range .Values.traefikMiddlewares.localOnlyAllowlist.localIpCIDRs }}
      - "{{ . }}"
      {{- end }}