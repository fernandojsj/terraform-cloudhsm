# Configurações obrigatórias
customer_name = "clouddog"
aws_region    = "us-east-1"
vpc_id        = "vpc-059a353e45d744191"
subnet_ids    = [
  "subnet-0d33ecdee95fa90a6",  # us-east-1a
  "subnet-0b5aa531791bcbb6d"   # us-east-1b
]

# Configurações do cluster 
cluster_name   = "meu-cluster-hsm"
hsm_type       = "hsm2m.medium"  
number_of_hsms = 1
mode           = "FIPS"  # ou "NON_FIPS"

# Configurações de segurança
allowed_cidr_blocks = [
  "10.0.0.0/16"
]

allowed_security_group_ids = [
  "sg-0cb335a0367ddab2c",
  "sg-0d7289c1084dfe9fe"
]

# Configurações de monitoramento
enable_cloudwatch_logs = false
log_retention_days     = 30

# Configurações de backup
backup_retention_policy = "NEVER_EXPIRE"  # ou número de dias como "365"

# Tags
tags = {
  Environment    = "production"
  Project        = "security-infrastructure"
  Owner          = "security-team@empresa.com"
  CostCenter     = "IT-Security"
  Compliance     = "PCI-DSS"
  BackupSchedule = "daily"
  Monitoring     = "24x7"
  ticket         = "CPD-2283"
}



