apiVersion: v1
kind: Namespace
metadata:
  name: {{ .Values.traefik.namespace }}
  annotations:
    argocd.argoproj.io/sync-wave: "20"
    reflector.v1.k8s.emberstack.com/reflects: "{{ .Values.certManager.namespace }}/{{ .Values.traefik.dashboard.tlsSecretName }}"