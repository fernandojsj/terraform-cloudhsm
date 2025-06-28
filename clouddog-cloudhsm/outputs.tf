# Outputs do CloudHSM Cluster
output "cluster_id" {
  description = "ID do cluster CloudHSM"
  value       = aws_cloudhsm_v2_cluster.main.cluster_id
}

output "cluster_state" {
  description = "Estado atual do cluster CloudHSM"
  value       = aws_cloudhsm_v2_cluster.main.cluster_state
}

output "cluster_certificates" {
  description = "Certificados do cluster CloudHSM"
  value       = aws_cloudhsm_v2_cluster.main.cluster_certificates
  sensitive   = true
}

# Outputs dos HSMs
output "hsm_ids" {
  description = "Lista de IDs dos HSMs"
  value       = aws_cloudhsm_v2_hsm.hsm[*].hsm_id
}

output "hsm_states" {
  description = "Lista de estados dos HSMs"
  value       = aws_cloudhsm_v2_hsm.hsm[*].hsm_state
}

output "hsm_eni_ids" {
  description = "Lista de IDs das interfaces de rede dos HSMs"
  value       = aws_cloudhsm_v2_hsm.hsm[*].hsm_eni_id
}

output "hsm_availability_zones" {
  description = "Lista de zonas de disponibilidade dos HSMs"
  value       = aws_cloudhsm_v2_hsm.hsm[*].availability_zone
}

# Outputs do Security Group
output "security_group_id" {
  description = "ID do security group do CloudHSM"
  value       = aws_security_group.cloudhsm.id
}

output "security_group_arn" {
  description = "ARN do security group do CloudHSM"
  value       = aws_security_group.cloudhsm.arn
}

# Outputs do IAM
output "service_role_arn" {
  description = "ARN da role de serviço do CloudHSM"
  value       = aws_iam_role.cloudhsm_service.arn
}

output "service_role_name" {
  description = "Nome da role de serviço do CloudHSM"
  value       = aws_iam_role.cloudhsm_service.name
}

# Outputs do CloudWatch (se habilitado)
output "cloudwatch_log_group_name" {
  description = "Nome do grupo de logs do CloudWatch"
  value       = var.enable_cloudwatch_logs ? aws_cloudwatch_log_group.cloudhsm[0].name : null
}

output "cloudwatch_log_group_arn" {
  description = "ARN do grupo de logs do CloudWatch"
  value       = var.enable_cloudwatch_logs ? aws_cloudwatch_log_group.cloudhsm[0].arn : null
}

# Outputs informativos
output "cluster_name" {
  description = "Nome do cluster CloudHSM"
  value       = local.cluster_name
}

output "hsm_type" {
  description = "Tipo dos HSMs utilizados"
  value       = var.hsm_type
}

output "number_of_hsms" {
  description = "Número de HSMs no cluster"
  value       = var.number_of_hsms
}

