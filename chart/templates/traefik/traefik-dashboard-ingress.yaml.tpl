apiVersion: traefik.io/v1alpha1
kind: IngressRoute
metadata:
  name: traefik-dashboard
  namespace: {{ .Values.traefik.namespace }}
  annotations:
    kubernetes.io/ingress.class: traefik-external
    argocd.argoproj.io/sync-wave: "24"
spec:
  entryPoints:
    # - local
    - websecure
  routes:
    - match: Host(`{{ .Values.traefik.dashboard.ingressUrl }}`)
      kind: Rule
      services:
        - name: api@internal
          kind: TraefikService
  tls:
    secretName: {{ .Values.traefik.dashboard.tlsSecretName }}
