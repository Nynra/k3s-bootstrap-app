apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: traefik
  namespace: {{ .Values.global.argocdConfig.namespace }}
  finalizers:
    - resources-finalizer.argocd.argoproj.io
  annotations:
    argocd.argoproj.io/sync-wave: "21"
spec:
  project: {{ .Values.project }}
  source:
    repoURL: https://helm.traefik.io/traefik
    chart: traefik
    targetRevision: {{ .Values.traefik.targetRevision }}
    helm:
      values: |
        globalArguments:
          - "--global.sendanonymoususage=false"
          - "--global.checknewversion=false"

        additionalArguments:
          - "--serversTransport.insecureSkipVerify=true"
          - "--log.level=INFO"

          - "--entrypoints.local.address=:19443"
          # - "--entrypoints.local.http.tls=true" # optional, only if you're using TLS

          # Add the crowdsec bouncer
          # - "--entrypoints.web.http.middlewares=traefik-crowdsec-bouncer@kubernetescrd"
          # - "--entrypoints.websecure.http.middlewares=traefik-crowdsec-bouncer@kubernetescrd"

        deployment:
          enabled: true
          replicas: {{ .Values.traefik.replicas }}
          annotations: {}
          podAnnotations: {}
          additionalContainers: []
          initContainers: []
          additionalVolumes:
            - name: crowdsec-lapi-secret-volume 
              secret:
                secretName: crowdsec-bouncer-token
          additionalVolumeMounts:
            - name: crowdsec-lapi-secret-volume
              mountPath: /etc/traefik/secrets/crowdsec-lapi
              readOnly: true

        ports:
          web:
            redirections:
              entrypoint:
                to: websecure
                priority: 10
          websecure:
            http3:
              enabled: true
            advertisedPort: 443
            tls:
              enabled: true
          # weblocal:
          #   # port: 19443
          #   port: 19000
          #   # expose: true
          #   exposedPort: 19443
          #   protocol: TCP

        ingressRoute:
          dashboard:
            enabled: false

        providers:
          kubernetesCRD:
            enabled: true
            ingressClass: traefik-external
            allowExternalNameServices: true
            namespaces: [] # All namespaces
          kubernetesIngress:
            enabled: true
            allowExternalNameServices: true
            namespaces: [] # All namespaces
            publishedService:
              enabled: false

        rbac:
          enabled: true

        service:
          enabled: true
          type: LoadBalancer
          annotations: {}
          labels: {}
          spec:
            loadBalancerIP: {{ .Values.traefik.loadBalancerIP }}
          loadBalancerSourceRanges: []
          externalIPs: []

  destination:
    server: {{ .Values.global.argocdConfig.server }}
    namespace: {{ .Values.traefik.namespace }}
  syncPolicy:
    automated:
      # prune: true
      selfHeal: true
    syncOptions:
      - CreateNamespace=true
