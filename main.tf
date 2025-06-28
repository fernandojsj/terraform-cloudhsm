module "cloudhsm_advanced" {
  source = "./clouddog-cloudhsm"

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


  # Configurações de segurança
  allowed_cidr_blocks = [
    var.allowed_cidr_blocks[0]
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


