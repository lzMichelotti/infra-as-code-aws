# Infra-as-Code AWS

Este repositório armazena configurações de infraestrutura como código e manifestos para deploy de aplicações, utilizando uma abordagem de GitOps.

## Estrutura do Repositório

O repositório está dividido em duas partes principais:

### 1. `meu-projeto-devops`

Este diretório contém a infraestrutura base provisionada com o Terraform.

- **`terraform/`**: Contém todos os arquivos de configuração do Terraform (`.tf`) para criar os recursos necessários na nuvem (AWS).
- **`dvn-workshop-apps/`**: Provavelmente contém o código fonte das aplicações ou configurações relacionadas.

### 2. `meu-projeto-devops-gitops`

Este diretório é focado na implantação contínua das aplicações utilizando GitOps.

- **`argocd/`**: Contém os manifestos e configurações do ArgoCD para sincronizar o estado do cluster Kubernetes com o que está definido neste repositório.
- **`backend/`**: Manifestos Kubernetes para o deploy da aplicação de backend.
- **`frontend/`**: Manifestos Kubernetes para o deploy da aplicação de frontend.
- **`kustomization.yml`**: Arquivo do Kustomize que gerencia e customiza os manifestos do Kubernetes para os diferentes ambientes.

## Como Funciona

1.  **Infraestrutura**: O Terraform no diretório `meu-projeto-devops` é usado para provisionar a infraestrutura necessária, como clusters Kubernetes (EKS), bancos de dados (RDS), etc.
2.  **Deploy Contínuo (GitOps)**: O ArgoCD (configurado em `meu-projeto-devops-gitops`) monitora este repositório. Qualquer alteração nos manifestos das aplicações (nos diretórios `frontend/`, `backend/`, etc.) é automaticamente aplicada ao cluster Kubernetes, garantindo que o ambiente esteja sempre sincronizado com o código.
