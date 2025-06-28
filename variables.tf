# Variáveis básicas do cliente e região
variable "customer_name" {
  description = "Nome do cliente para identificação dos recursos"
  type        = string
}

variable "aws_region" {
  description = "Região AWS onde os recursos serão criados"
  type        = string
}

# Configurações de rede
variable "vpc_id" {
  description = "ID da VPC onde o cluster CloudHSM será criado"
  type        = string
}

variable "subnet_ids" {
  description = "Lista de IDs das subnets para o cluster CloudHSM (mínimo 2 AZs diferentes)"
  type        = list(string)
  validation {
    condition     = length(var.subnet_ids) >= 2
    error_message = "Pelo menos 2 subnets em AZs diferentes são necessárias."
  }
}

# Configurações do CloudHSM Cluster
variable "cluster_name" {
  description = "Nome do cluster CloudHSM"
  type        = string
  default     = null
}

variable "hsm_type" {
  description = "Tipo do HSM (hsm1.medium ou hsm2m.medium)"
  type        = string
  default     = "hsm2m.medium"
  validation {
    condition     = contains(["hsm1.medium", "hsm2m.medium"], var.hsm_type)
    error_message = "Tipo de HSM deve ser hsm1.medium ou hsm2m.medium."
  }
}

variable "number_of_hsms" {
  description = "Número de HSMs no cluster (mínimo 2 para alta disponibilidade)"
  type        = number
  validation {
    condition     = var.number_of_hsms >= 1
    error_message = "Número de HSMs deve ser pelo menos 1."
  }
}

variable "mode" {
  description = "Modo de criptografia do cluster (FIPS ou NON_FIPS)"
  type        = string
  validation {
    condition     = contains(["FIPS", "NON_FIPS"], var.mode)
    error_message = "Modo deve ser FIPS ou NON_FIPS."
  }
  
}

# Configurações de segurança
variable "allowed_cidr_blocks" {
  description = "Lista de blocos CIDR permitidos para acesso ao CloudHSM"
  type        = list(string)
  default     = []
}

variable "allowed_security_group_ids" {
  description = "Lista de IDs de security groups permitidos para acesso ao CloudHSM"
  type        = list(string)
  default     = []
}

# Tags
variable "tags" {
  description = "Tags aplicadas a todos os recursos CloudHSM"
  type        = map(string)
}

# Configurações de backup
variable "backup_retention_policy" {
  description = "Política de retenção de backup (NEVER_EXPIRE ou número de dias)"
  type        = string
  default     = "NEVER_EXPIRE"
}

# Configurações de monitoramento
variable "enable_cloudwatch_logs" {
  description = "Habilitar logs do CloudWatch para o CloudHSM"
  type        = bool
}

variable "log_retention_days" {
  description = "Dias de retenção dos logs do CloudWatch"
  type        = number
  default     = 30
}