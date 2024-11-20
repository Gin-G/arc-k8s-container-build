# arc-k8s-container-build
Repo to test ARC container builds on K8s

This repo uses GitHub Actions Runner Controller to spin up a self hosted runner. That runner then submits a job to Argo Workflows via GitHub Actions

The Argo Workflow uses Kaniko to build container images without root privilege or access to a daemon