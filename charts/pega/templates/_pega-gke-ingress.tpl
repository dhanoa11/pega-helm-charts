{{- define "pega.gke.ingress" -}}
# Ingress to be used for {{ .name }}
kind: Ingress
apiVersion: extensions/v1beta1
metadata:
  name: {{ .name }}
  namespace: {{ .root.Release.Namespace }}
  {{- if (eq .node.ingress.tls.enabled true) }}
  annotations:
    kubernetes.io/ingress.allow-http: "false"
  {{- if (eq .node.ingress.tls.useManagedCertificate true) }}
    networking.gke.io/managed-certificates: managed-certificate-{{ .node.name }}
  {{ end }}
    {{ toYaml .node.ingress.tls.ssl_annotation }}
  {{ end }}
spec:
{{- if (eq .node.ingress.tls.enabled true) }}
{{- if .node.ingress.tls.secretName }}
{{ include "tlssecretsnippet" . }}
{{ end }}
{{ end }}
  backend:
    serviceName: {{ .name }}
    servicePort: {{ .node.service.port }}
  rules:
  # The calls will be redirected from {{ .node.domain }} to below mentioned backend serviceName and servicePort.
  # To access the below service, along with {{ .node.domain }}, http/https port also has to be provided in the URL.
  - host: {{ .node.ingress.domain }}
    http:
      paths:
      - backend:
          serviceName: {{ .name }}
          servicePort: {{ .node.service.port }}
---
{{- end }}