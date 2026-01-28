# Estudo DevOps: Infraestrutura como Código e GitOps na AWS

Este repositório é um projeto de estudo completo que demonstra um fluxo de trabalho de DevOps moderno para implantar uma aplicação full-stack na AWS. Ele abrange desde a provisionamento da infraestrutura com Terraform até a implantação contínua com GitOps usando ArgoCD.

## Visão Geral para DevOps

O objetivo deste projeto é fornecer um exemplo prático de como automatizar a criação e a gestão de uma arquitetura de nuvem robusta e o ciclo de vida de uma aplicação.

O fluxo de trabalho principal é:
1.  **Infraestrutura como Código (IaC)**: O Terraform é usado para definir e provisionar toda a infraestrutura de nuvem de forma declarativa e reprodutível.
2.  **Conteinerização**: A aplicação (frontend e backend) é conteinerizada usando Docker, garantindo consistência entre os ambientes.
3.  **Orquestração**: O Amazon EKS (Kubernetes) é usado para orquestrar os contêineres, gerenciando o escalonamento, a disponibilidade e o networking.
4.  **Entrega Contínua com GitOps**: O ArgoCD é usado para implementar o GitOps. O repositório Git é a única fonte da verdade. Qualquer alteração nos manifestos ou na versão da imagem no Git é automaticamente sincronizada com o cluster Kubernetes.

---

## Estrutura do Repositório

-   `README.md`: Este arquivo.
-   `estudo-devops/`: Contém o código-fonte da aplicação e o código da infraestrutura.
    -   `dvn-workshop-apps/`: O código da aplicação.
        -   `backend/`: Aplicação ASP.NET Core.
        -   `frontend/`: Aplicação Next.js.
    -   `terraform/`: Código Terraform dividido em stacks (backend, networking, EKS).
-   `estudo-devops-gitops/`: Contém os manifestos Kubernetes para a implantação via GitOps.
    -   `argocd/`: Definição da `Application` do ArgoCD.
    -   `backend/`, `frontend/`: Manifestos de `Deployment` e `Service` do Kubernetes.
    -   `kustomization.yml`: Arquivo Kustomize que gerencia os manifestos e as imagens de contêiner.

---

## Stack de Tecnologia

-   **Cloud**: AWS
-   **IaC**: Terraform
-   **Orquestração de Contêineres**: Amazon EKS (Kubernetes)
-   **Conteinerização**: Docker
-   **GitOps**: ArgoCD, Kustomize
-   **Aplicação**: Next.js (Frontend), ASP.NET Core (Backend)

---

## Pipeline de Implantação (CI/CD)

Este projeto foca na parte de **Entrega Contínua (CD)** com GitOps.

1.  **Gatilho**: Uma alteração é mesclada no branch `master` do repositório Git. Isso pode ser uma atualização nos manifestos do Kubernetes, no `kustomization.yml` (por exemplo, uma nova tag de imagem) ou no próprio código da aplicação.
2.  **Detecção**: O ArgoCD, que monitora o repositório, detecta que o estado definido no Git é diferente do estado atual no cluster EKS.
3.  **Sincronização**: O ArgoCD inicia o processo de sincronização, aplicando as alterações necessárias ao cluster. Isso pode envolver a criação, atualização ou exclusão de recursos do Kubernetes.
4.  **Implantação**: O Kubernetes realiza um rolling update para implantar a nova versão da aplicação sem tempo de inatividade.

*Nota: Um pipeline de **Integração Contínua (CI)** completo (não implementado aqui) seria responsável por rodar testes, construir as imagens Docker e enviá-las para um registro de contêineres (como o Amazon ECR) antes que o processo de CD comece.*

---

## Como Implantar

Siga os passos abaixo para provisionar a infraestrutura e implantar a aplicação.

### Pré-requisitos

-   [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)
-   [AWS CLI](https://aws.amazon.com/cli/) com credenciais configuradas
-   [`kubectl`](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
-   [`docker`](https://docs.docker.com/get-docker/) (Opcional, se você for construir suas próprias imagens)

### Passos da Implantação

1.  **Provisionar a Infraestrutura com Terraform**:
    -   Navegue para cada pasta dentro de `estudo-devops/terraform` na ordem de `00` a `02` e execute `terraform init` e `terraform apply`.

    ```sh
    # 1. Backend Remoto
    cd estudo-devops/terraform/00-remote-backend-stack/
    terraform init && terraform apply -auto-approve

    # 2. Rede
    cd ../01-networking-stack/
    terraform init && terraform apply -auto-approve

    # 3. Cluster EKS
    cd ../02-eks-cluster-stack/
    terraform init && terraform apply -auto-approve
    ```

2.  **Configurar o `kubectl`**:
    -   Após a criação do cluster EKS, configure seu `kubectl` para se conectar a ele. O Terraform fornecerá o comando necessário na saída.

    ```sh
    aws eks update-kubeconfig --region <sua-regiao> --name <nome-do-cluster>
    ```

3.  **Implantar o ArgoCD no Cluster**:
    -   Crie o namespace e instale o ArgoCD.

    ```sh
    kubectl create namespace argocd
    kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
    ```

4.  **Implantar a Aplicação via ArgoCD**:
    -   Aplique o manifesto da `Application` que instrui o ArgoCD a gerenciar seu projeto.

    ```sh
    kubectl apply -f estudo-devops-gitops/argocd/application.yml
    ```
    - O ArgoCD irá então ler a configuração do `estudo-devops-gitops` no repositório e implantar o frontend e o backend no cluster.

5.  **Verificar a Implantação**:
    -   Verifique os pods no namespace `default` para ver se a aplicação está rodando.

    ```sh
    kubectl get pods -n default
    ```
    -   Acesse a UI do ArgoCD para monitorar o status da sincronização e da saúde da aplicação.

    ```sh
    kubectl port-forward svc/argocd-server -n argocd 8080:443
    ```
    -   Acesse `https://localhost:8080` no seu navegador.
