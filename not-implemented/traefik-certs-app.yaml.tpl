apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: traefik-certs-app
  namespace: {{ .Values.argoConfig.namespace }}
  finalizers:
    - resources-finalizer.argocd.argoproj.io
  annotations:
    argocd.argoproj.io/sync-wave: "-8"
spec:
  project: {{ .Values.project }}
  source:
    repoURL: https://gitlab.structam.nl/homelab/k8/core/traefik-cert-manager.git
    path: charts/traefik-cert-manager
    targetRevision: {{ .Values.traefikCertsApp.targetRevision }}
    helm:
      values: |
        project: {{ .Values.project }}
        
        argoConfig:
          project: {{ .Values.argoConfig.project }}
          server: {{ .Values.argoConfig.server }}
          namespace: {{ .Values.argoConfig.namespace }}
        
        traefikApp:
          loadBalancerIP: {{ .Values.traefikCertsApp.traefikApp.loadBalancerIP }}
        
        certManagerApp:
          issuers:
            cloudflareCredentials:
              email: {{ .Values.traefikCertsApp.certManagerApp.issuers.cloudflareCredentials.email }}
              secretName: {{ .Values.traefikCertsApp.certManagerApp.issuers.cloudflareCredentials.secretName }}
              secretKey: {{ .Values.traefikCertsApp.certManagerApp.issuers.cloudflareCredentials.secretKey }}
          domains:
            {{- range .Values.traefikCertsApp.certManagerApp.domains }}
            - "{{ . }}"
            {{- end }}

        crowdsecApp:
          disableOnlineApi: {{ .Values.traefikCertsApp.crowdsecApp.disableOnlineApi }}
          secrets:
            externalSecret:
              name: {{ .Values.traefikCertsApp.crowdsecApp.secrets.externalSecret.name }}
              remoteSecretName: {{ .Values.traefikCertsApp.crowdsecApp.secrets.externalSecret.remoteSecretName }}
              remoteSecretStore: {{ .Values.traefikCertsApp.crowdsecApp.secrets.externalSecret.remoteSecretStore }}
              csLapiSecretPropertyName: {{ .Values.traefikCertsApp.crowdsecApp.secrets.externalSecret.csLapiSecretPropertyName }}
              registrationTokenPropertyName: {{ .Values.traefikCertsApp.crowdsecApp.secrets.externalSecret.registrationTokenPropertyName }}
              enrollKeyPropertyName: {{ .Values.traefikCertsApp.crowdsecApp.secrets.externalSecret.enrollKeyPropertyName }}
          dashboard:
            enabled: {{ .Values.traefikCertsApp.crowdsecApp.dashboard.enabled }}

  destination:
    server: {{ .Values.argoConfig.server }}
    namespace: {{ .Values.traefikCertsApp.namespace }}
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
      - CreateNamespace=true
