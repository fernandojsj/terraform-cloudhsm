# Módulo Terraform AWS CloudHSM

Este módulo Terraform cria e gerencia um cluster AWS CloudHSM com todas as configurações necessárias para um ambiente de produção seguro.

## 📋 Funcionalidades

- ✅ Criação de cluster CloudHSM com múltiplos HSMs
- ✅ Configuração automática de Security Groups
- ✅ Distribuição de HSMs entre múltiplas Availability Zones
- ✅ Integração com CloudWatch Logs
- ✅ Configuração de IAM Roles e Policies
- ✅ Suporte a tags personalizadas
- ✅ Validações de entrada para garantir configurações corretas

## 🏗️ Arquitetura

O módulo cria os seguintes recursos:

```
┌─────────────────────────────────────────────────────────────┐
│                        VPC                                  │
│  ┌─────────────────┐              ┌─────────────────┐       │
│  │   Subnet AZ-A   │              │   Subnet AZ-B   │       │
│  │  ┌───────────┐  │              │  ┌───────────┐  │       │
│  │  │    HSM    │  │              │  │    HSM    │  │       │
│  │  └───────────┘  │              │  └───────────┘  │       │
│  └─────────────────┘              └─────────────────┘       │
│           │                                 │               │
│           └─────────────────────────────────┘               │
│                         │                                   │
│                ┌─────────────────┐                          │
│                │ Security Group  │                          │
│                │  Ports 2223-25  │                          │
│                └─────────────────┘                          │
└─────────────────────────────────────────────────────────────┘
```

## 📦 Recursos Criados

| Recurso | Descrição |
|---------|-----------|
| `aws_cloudhsm_v2_cluster` | Cluster principal do CloudHSM |
| `aws_cloudhsm_v2_hsm` | Instâncias HSM individuais |
| `aws_security_group` | Security group para comunicação HSM |
| `aws_iam_role` | Role de serviço para CloudHSM |
| `aws_iam_role_policy` | Políticas necessárias para operação |
| `aws_cloudwatch_log_group` | Grupo de logs (opcional) |

## 🚀 Uso Básico

```hcl
module "cloudhsm" {
  source = "./terraform-aws-cloudhsm"

  # Configurações obrigatórias
  customer_name = "minha-empresa"
  aws_region    = "us-east-1"
  vpc_id        = "vpc-12345678"
  subnet_ids    = ["subnet-12345678", "subnet-87654321"]

  # Configurações opcionais
  cluster_name   = "meu-cluster-hsm"
  number_of_hsms = 2
  hsm_type       = "hsm2m.medium"

  # Tags
  tags = {
    Environment = "production"
    Project     = "security"
  }
}
```

## 📝 Variáveis de Entrada

### Obrigatórias

| Nome | Tipo | Descrição |
|------|------|-----------|
| `customer_name` | `string` | Nome do cliente para identificação |
| `aws_region` | `string` | Região AWS onde criar os recursos |
| `vpc_id` | `string` | ID da VPC |
| `subnet_ids` | `list(string)` | Lista de subnet IDs (mín. 2) |

### Recursos

| Nome | Tipo | Padrão | Descrição |
|------|------|--------|-----------|
| `cluster_name` | `string` | `null` | Nome do cluster (auto-gerado se null) |
| `hsm_type` | `string` | `"hsm2m.medium"` | Tipo do HSM |
| `number_of_hsms` | `number` | `2` | Número de HSMs |
| `allowed_cidr_blocks` | `list(string)` | `[]` | CIDRs permitidos |
| `allowed_security_group_ids` | `list(string)` | `[]` | Security groups permitidos |
| `enable_cloudwatch_logs` | `bool` | `true` | Habilitar logs CloudWatch |
| `log_retention_days` | `number` | `30` | Dias de retenção dos logs |
| `backup_retention_policy` | `string` | `"NEVER_EXPIRE"` | Política de backup |
| `tags` | `map(string)` | `{}` | Tags aplicadas aos recursos |
| `mode` | `string` | `FIPS` | Modo de criptografia do cluster  

## 📤 Outputs

### Principais

| Nome | Descrição |
|------|-----------|
| `cluster_id` | ID do cluster CloudHSM |
| `cluster_state` | Estado atual do cluster |
| `hsm_ids` | Lista de IDs dos HSMs |

### Segurança

| Nome | Descrição |
|------|-----------|
| `security_group_id` | ID do security group |
| `service_role_arn` | ARN da role de serviço |

### Monitoramento

| Nome | Descrição |
|------|-----------|
| `cloudwatch_log_group_name` | Nome do grupo de logs |
| `cloudwatch_log_group_arn` | ARN do grupo de logs |

## 🔧 Exemplos de Uso

### Exemplo 1: Configuração Básica

```hcl
module "cloudhsm_basic" {
  source = "./terraform-aws-cloudhsm"

  # Configurações obrigatórias
  customer_name = var.customer_name
  aws_region    = var.aws_region
  vpc_id        = var.vpc_id
  subnet_ids    = [var.subnet_ids[0], var.subnet_ids[1]]

  # Configurações opcionais com valores padrão
  cluster_name   = var.cluster_name != null ? var.cluster_name : "${var.customer_name}-cloudhsm-cluster"
  hsm_type       = var.hsm_type
  number_of_hsms = var.number_of_hsms
  mode           = var.mode 

  # Tags
  tags = var.tags
}
```

### Exemplo 2: Configuração Avançada com Segurança Personalizada

```hcl
module "cloudhsm_advanced" {
  source = "./terraform-aws-cloudhsm"

  # Configurações básicas
  customer_name = var.customer_name
  aws_region    = var.aws_region
  vpc_id        = var.vpc_id
  subnet_ids    = [var.subnet_ids[0], var.subnet_ids[1], var.subnet_ids[2]]

  # Configurações do cluster
  cluster_name   = var.cluster_name != null ? var.cluster_name : "${var.customer_name}-cloudhsm-cluster"
  hsm_type       = var.hsm_type
  number_of_hsms = var.number_of_hsms
  mode           = var.mode 

  # Configurações de segurança
  allowed_cidr_blocks = [
    var.allowed_cidr_blocks[0],
    var.allowed_cidr_blocks[1]
  ]
  
  allowed_security_group_ids = [
    var.allowed_security_group_ids[0],
    var.allowed_security_group_ids[1]
  ]

  # Configurações de monitoramento
  enable_cloudwatch_logs = var.enable_cloudwatch_logs
  log_retention_days     = var.log_retention_days

  # Configurações de backup
  backup_retention_policy = var.backup_retention_policy

  # Tags
  tags = var.tags
}
```

### Exemplo 3: Configuração para Desenvolvimento/Teste

```hcl
module "cloudhsm_dev" {
  source = "./terraform-aws-cloudhsm"

  # Configurações básicas
  customer_name = var.customer_name
  aws_region    = var.aws_region
  vpc_id        = var.vpc_id
  subnet_ids    = [var.subnet_ids[0], var.subnet_ids[1]]

  # Configurações do cluster
  cluster_name   = var.cluster_name != null ? var.cluster_name : "${var.customer_name}-cloudhsm-cluster"
  hsm_type       = var.hsm_type
  number_of_hsms = var.number_of_hsms
  mode           = var.mode 

  # Configurações de monitoramento reduzidas
  enable_cloudwatch_logs = var.enable_cloudwatch_logs
  log_retention_days     = var.log_retention_days

  # Tags
  tags = var.tags
}
```

## ⚠️ Considerações Importantes

### Custos
- CloudHSM tem custos significativos (aproximadamente $1.45/hora por HSM)
- Considere usar apenas 1 HSM para desenvolvimento
- Para produção, recomenda-se mínimo 2 HSMs para alta disponibilidade

### Segurança
- Configure adequadamente os `allowed_cidr_blocks` e `allowed_security_group_ids`
- Use sempre HTTPS/TLS para comunicação com aplicações
- Mantenha os certificados seguros

### Rede
- HSMs devem estar em subnets privadas
- Certifique-se de que as subnets estão em AZs diferentes
- Configure adequadamente as rotas de rede

### Backup
- CloudHSM faz backup automático
- Configure a política de retenção conforme necessário
- Teste regularmente os procedimentos de restore

## 🔍 Validações

O módulo inclui validações para:

- ✅ Mínimo de 2 subnets
- ✅ Tipos de HSM válidos
- ✅ Número mínimo de HSMs

## 📋 Pré-requisitos

1. **Terraform** >= 1.0
2. **Provider AWS** >= 4.0
3. **Permissões IAM** adequadas:
   - `cloudhsm:*`
   - `ec2:*`
   - `iam:*`
   - `logs:*`

**⚠️ Atenção**: A destruição do CloudHSM é irreversível e pode resultar em perda de dados criptográficos.