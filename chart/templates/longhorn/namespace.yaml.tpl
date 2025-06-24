apiVersion: v1
kind: Namespace
metadata:
  name: {{ .Values.longhorn.namespace }}
  annotations:
    argocd.argoproj.io/sync-wave: "-5"
    reflector.v1.k8s.emberstack.com/reflects: "{{ .Values.certManager.namespace }}/{{ .Values.longhorn.dashboard.tlsSecretName }}"