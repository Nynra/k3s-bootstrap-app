apiVersion: batch/v1
kind: Job
metadata:
  name: wait-for-cert-manager-crds
  namespace: {{ .Values.certManager.namespace }}
  annotations:
    argocd.argoproj.io/hook: Sync
    argocd.argoproj.io/sync-wave: "11"
    # argocd.argoproj.io/hook-delete-policy: HookSucceeded
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
            - "--timeout=180s" # Increase timeout for multiple CRDs
            - "crd/certificaterequests.cert-manager.io"
            - "crd/certificates.cert-manager.io"
            - "crd/clusterissuers.cert-manager.io"
      restartPolicy: Never
  backoffLimit: 1
