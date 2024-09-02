# Terraform AWS S3 State Management

Este projeto configura a infraestrutura básica na AWS utilizando o Terraform. Ele cria e gerencia um bucket S3 para armazenar o estado do Terraform e habilita o versionamento para preservar a integridade dos estados.

## Pré-requisitos

- [Terraform](https://www.terraform.io/downloads.html) instalado.
- Uma conta AWS configurada com credenciais apropriadas.
- Perfil AWS configurado (`gustavo` neste exemplo).

## Estrutura do Projeto

- `main.tf`: Arquivo principal que define os recursos da AWS e a configuração do backend.

## Providers

Este projeto utiliza o provider AWS da HashiCorp.

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.60.0"
    }
  }

  backend "s3" {
    bucket  = "gustavo-state-bucket-tf"
    region  = "sa-east-1"
    key     = "terraform.tfstate"
    encrypt = true
    profile = "gustavo"
  }
}

provider "aws" {
  profile = "gustavo"
  region  = "sa-east-1"
}
```

## Recursos

### S3 Bucket para o Estado do Terraform

Um bucket S3 é criado para armazenar o estado do Terraform.

```hcl
resource "aws_s3_bucket" "terraform_state" {
  bucket = var.state_bucket
  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.bucket

  versioning_configuration {
    status = "Enabled"
  }

  depends_on = [
    aws_s3_bucket.terraform_state
  ]
}
```

## Variáveis

- `state_bucket`: Nome do bucket S3 que será criado para armazenar o estado do Terraform.

## Iniciando o Projeto

1. Clone o repositório.
2. Inicialize o Terraform:

   ```bash
   terraform init
    ```   
3. Aplique as mudanças:
    ```bash
    terraform apply
    ````
4. Confirme a criação do bucket S3 e o versionamento.

## Notas
- O bucket S3 possui prevent_destroy habilitado para evitar a exclusão acidental.
- O versionamento do bucket está ativado para preservar versões anteriores do estado.