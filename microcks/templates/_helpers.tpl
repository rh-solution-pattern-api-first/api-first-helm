{{/*
Expand the name of the chart.
*/}}
{{- define "microcks.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "microcks.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "microcks.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "microcks.labels" -}}
helm.sh/chart: {{ include "microcks.chart" . }}
{{ include "microcks.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/part-of: {{ include "microcks.name" . }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "microcks.selectorLabels" -}}
app.kubernetes.io/name: {{ include "microcks.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Selector labels mongo
*/}}
{{- define "microcks.mongodb.selectorLabels" -}}
app.kubernetes.io/name: {{ include "microcks.name" . }}-mongodb
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "microcks.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "microcks.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
MongoDb url
*/}}
{{- define "microcks.mongodb.uri" -}}
{{- $output := "" }}
{{- if .Values.mongodb.uri }}
{{- $output = .Values.mongodb.uri }}
{{- else }}
{{- $output = printf "%s-%s" (include "microcks.name" .) "mongodb:27017" }}
{{- end }}
{{- $output }}
{{- end }}
