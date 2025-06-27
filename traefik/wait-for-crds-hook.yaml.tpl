apiVersion: batch/v1
kind: Job
metadata:
  name: wait-for-traefik-crds
  namespace: {{ .Values.traefik.namespace }}
  annotations:
    argocd.argoproj.io/hook: Sync
    argocd.argoproj.io/sync-wave: "-8"
    argocd.argoproj.io/hook-delete-policy: HookSucceeded
spec:
  template:
    spec:
      serviceAccountName: bootstrap-app-crd-waiter
      containers:
        - name: kubectl
          image: bitnami/kubectl:latest
          command:
            - "kubectl"
            - "wait"
            - "--for"
            - "condition=established"
            - "--timeout=180s"
            - "crd/ingressroutes.traefik.io"
            - "crd/middlewares.traefik.io"
            - "crd/middlewaretcps.traefik.io"
      restartPolicy: Never
  backoffLimit: 1
