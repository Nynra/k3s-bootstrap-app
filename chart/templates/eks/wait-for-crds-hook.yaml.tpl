apiVersion: batch/v1
kind: Job
metadata:
  name: wait-for-eks-crds
  namespace: {{ .Values.eks.onepasswordConnect.namespace }}
  annotations:
    argocd.argoproj.io/hook: Sync
    argocd.argoproj.io/sync-wave: "2"
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
            - "crd/secretstores.external-secrets.io"
            - "crd/passwords.generators.external-secrets.io"
      restartPolicy: Never
  backoffLimit: 1
