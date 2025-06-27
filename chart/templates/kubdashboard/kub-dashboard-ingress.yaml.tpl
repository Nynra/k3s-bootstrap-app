apiVersion: traefik.io/v1alpha1
kind: IngressRoute
metadata:
  name: kub-dashboard
  namespace: {{ .Values.kubDashboard.namespace }}
  annotations:
    kubernetes.io/ingress.class: traefik-external
    argocd.argoproj.io/sync-wave: "30"
spec:
  entryPoints:
    - websecure
  routes:
    - match: Host(`{{ .Values.kubDashboard.ingressUrl }}`)
      kind: Rule
      middlewares:
        - name: lan-only-ref
          kind: TraefikService
      services:
        - name: kub-dashboard-kong-proxy
          # kind: Service
          port: 443
  tls:
    secretName: {{ .Values.kubDashboard.tlsSecretName }}
