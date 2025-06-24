# app-1password-connect.yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: crowdsec-app
  namespace: {{ .Values.global.argocdConfig.namespace }}
  finalizers:
    - resources-finalizer.argocd.argoproj.io
  annotations:
    argocd.argoproj.io/sync-wave: "-15"
spec:
  destination:
    namespace: {{ .Values.crowdsec.namespace }}
    server: {{ .Values.global.argocdConfig.server }}
  project: {{ .Values.project }}
  source:
    repoURL: https://crowdsecurity.github.io/helm-charts
    chart: crowdsec
    targetRevision: {{ .Values.crowdsec.targetRevision }}
    helm:
      values: |
        config:
          config.yaml.local: |
{{ .Values.crowdsec.config.config_yaml_local | nindent 12 }}
        secrets:
          externalSecrets:
            name: {{ .Values.crowdsec.externalSecret.name }}
        agent:
          enabled: {{ .Values.crowdsec.agent.enabled }}
          isDeployment: {{ .Values.crowdsec.agent.isDeployment }}
          # Login using username and password
          tlsClientAuth: false
          acquisition:
            - namespace: {{ .Values.traefik.namespace }}
              podName: traefik-*
              program: traefik
          env:
            - name: DISABLE_ONLINE_API
              value: {{ .Values.crowdsec.disableOnlineApi | quote }}
            - name: PARSERS
              value: "crowdsecurity/cri-logs"
            - name: COLLECTIONS
              value: "crowdsecurity/traefik"
          tolerations:
            # Run on all nodes, including control plane nodes
            - key: node-role.kubernetes.io/control-plane
              operator: Equal
              effect: NoSchedule
        lapi:
          env:
            - name: DISABLE_ONLINE_API
              value: {{ .Values.crowdsec.disableOnlineApi | quote}}
          dashboard:
            enabled: {{ .Values.crowdsec.dashboard.enabled }}
            persistentVolume:
              config:
                enabled: true
                storageClassName: "longhorn"
        appsec:
          enabled: {{ .Values.crowdsec.appsec.enabled }}

  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
      - CreateNamespace=true
