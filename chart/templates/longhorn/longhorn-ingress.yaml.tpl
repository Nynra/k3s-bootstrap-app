apiVersion: traefik.io/v1alpha1
kind: IngressRoute
metadata:
  name: longhorn-ingress
  namespace: {{ .Values.longhorn.namespace }}
  annotations:
    kubernetes.io/ingress.class: traefik-external
    argocd.argoproj.io/sync-wave: "29"
spec:
  entryPoints:
    - websecure
  routes:
    - match: Host(`{{ .Values.longhorn.dashboard.ingressUrl }}`)
      kind: Rule
      middlewares:
        - name: lan-only-ref
          kind: TraefikService
      services:
        - name: longhorn-frontend
          port: 80
  tls:
    secretName: {{ .Values.longhorn.dashboard.tlsSecretName }}
