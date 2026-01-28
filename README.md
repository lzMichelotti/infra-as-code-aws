# Projeto de Infraestrutura como Código e GitOps para Aplicação Web Full-Stack

Este repositório contém o código-fonte de uma aplicação web full-stack, a infraestrutura como código (IaC) para provisionar os recursos na AWS, e as configurações de GitOps para automação do deploy.

## Visão Geral da Arquitetura

O projeto é composto por três partes principais:

1.  **Aplicação**: Uma aplicação web com um frontend em Next.js e um backend em ASP.NET Core.
2.  **Infraestrutura como Código (IaC)**: Código Terraform para provisionar a infraestrutura na AWS, incluindo a rede e um cluster EKS.
3.  **GitOps**: Manifestos Kubernetes e configuração do ArgoCD para o deploy contínuo da aplicação no cluster EKS.

---

## 1. Aplicação (`meu-projeto-devops`)

O código-fonte da aplicação está localizado na pasta `meu-projeto-devops/dvn-workshop-apps`.

### Backend

-   **Localização**: `meu-projeto-devops/dvn-workshop-apps/backend/YoutubeLiveApp`
-   **Framework**: ASP.NET Core
-   **Descrição**: Uma API web que serve como backend para a aplicação. Inclui health checks e documentação de API com Swagger, que é exposto no endpoint `/backend/swagger`.

### Frontend

-   **Localização**: `meu-projeto-devops/dvn-workshop-apps/frontend/youtube-live-app`
-   **Framework**: Next.js com TypeScript e Tailwind CSS
-   **Descrição**: A interface de usuário da aplicação, intitulada "Workshop DevOps na Nuvem v2.0".

---

## 2. Infraestrutura como Código (`meu-projeto-devops/terraform`)

A infraestrutura é gerenciada com Terraform e está dividida em três stacks para modularidade.

### Stack 00: Remote Backend (`00-remote-backend-stack`)

-   **Descrição**: Esta stack provisiona os recursos necessários para o armazenamento do estado do Terraform (remote state).
-   **Recursos**:
    -   Um bucket S3 (`meu-projeto-devops-tfstate`) para armazenar os arquivos de estado (`.tfstate`).
    -   Uma tabela no DynamoDB para o controle de lock do estado, garantindo a consistência em execuções concorrentes.

### Stack 01: Rede (`01-networking-stack`)

-   **Descrição**: Provisiona toda a infraestrutura de rede (VPC) para a aplicação.
-   **Recursos**:
    -   VPC (Virtual Private Cloud).
    -   Subnets públicas e privadas.
    -   Internet Gateway para acesso à internet nas subnets públicas.
    -   NAT Gateway para permitir que os recursos nas subnets privadas acessem a internet.
    -   Tabelas de rotas para controlar o fluxo de tráfego.

### Stack 02: Cluster EKS (`02-eks-cluster-stack`)

-   **Descrição**: Provisiona o cluster Kubernetes gerenciado pela AWS.
-   **Recursos**:
    -   Cluster Amazon EKS (Elastic Kubernetes Service).
    -   Node Group de instâncias EC2 que se juntarão ao cluster.
    -   IAM Roles e Policies necessárias para o funcionamento do cluster e dos nodes.

---

## 3. GitOps (`meu-projeto-devops-gitops`)

A automação do deploy é feita utilizando a abordagem GitOps com ArgoCD e Kustomize.

### ArgoCD

-   **Localização do arquivo**: `meu-projeto-devops-gitops/argocd/application.yml`
-   **Descrição**: Define uma aplicação no ArgoCD chamada `dvn-workshop-jan`.
-   **Configuração**:
    -   Aponta para o repositório `https://github.com/lzMichelotti/infra-as-code-aws.git`.
    -   Monitora o caminho `.` (a raiz do repositório `meu-projeto-devops-gitops`).
    -   Faz o deploy dos manifestos no namespace `default` do cluster Kubernetes onde o ArgoCD está sendo executado.
    -   A política de sincronização (`syncPolicy`) está configurada com `selfHeal: true`, o que significa que o ArgoCD tentará corrigir automaticamente qualquer desvio entre o estado desejado (no Git) and o estado atual (no cluster).

### Kustomize

-   **Localização do arquivo**: `meu-projeto-devops-gitops/kustomization.yml`
-   **Descrição**: Orquestra a geração dos manifestos Kubernetes.
-   **Recursos**:
    -   Inclui os deployments e services para o frontend e o backend.
    -   Gerencia as imagens de container, apontando para um repositório ECR (`236510206699.dkr.ecr.us-west-1.amazonaws.com/infra-as-code-aws/production/...`).

### Manifestos Kubernetes

-   **Localização**: Pastas `frontend` e `backend` dentro de `meu-projeto-devops-gitops`.
-   **Descrição**: Contêm os arquivos `deployment.yml` e `service.yml` que definem como a aplicação será executada e exposta no Kubernetes.
-   **Deployments**: Definem os pods da aplicação, incluindo a imagem do container e o número de réplicas.
-   **Services**: Expõem os deployments como um serviço de rede, permitindo a comunicação entre o frontend, o backend e o tráfego externo.