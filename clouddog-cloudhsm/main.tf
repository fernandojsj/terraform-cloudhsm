# Locals para organização e reutilização
locals {
  cluster_name = var.cluster_name != null ? var.cluster_name : "${var.customer_name}-cloudhsm-cluster"
  
  # Tags simplificadas
  tags = var.tags
}

# Security Group para o CloudHSM
resource "aws_security_group" "cloudhsm" {
  name_prefix = "${local.cluster_name}-sg"
  description = "Security group para CloudHSM cluster ${local.cluster_name}"
  vpc_id      = var.vpc_id

  # Regras de entrada para CloudHSM (porta 2223-2225)
  ingress {
    description = "CloudHSM Client Communication"
    from_port   = 2223
    to_port     = 2225
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
    security_groups = var.allowed_security_group_ids
  }

  # Regra de saída (permite todo tráfego de saída)
  egress {
    description = "All outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.tags, {
    Name = "${local.cluster_name}-security-group"
  })

  lifecycle {
    create_before_destroy = true
  }
}

# CloudHSM Cluster
resource "aws_cloudhsm_v2_cluster" "main" {
  hsm_type   = var.hsm_type
  subnet_ids = var.subnet_ids
  mode       = var.mode

  tags = merge(local.tags, {
    Name = local.cluster_name
  })
}

# CloudHSM HSM Instances
resource "aws_cloudhsm_v2_hsm" "hsm" {
  count      = var.number_of_hsms
  cluster_id = aws_cloudhsm_v2_cluster.main.cluster_id
  
  # Distribui os HSMs entre as subnets disponíveis
  subnet_id = var.subnet_ids[count.index % length(var.subnet_ids)]
  
}

# CloudWatch Log Group (se habilitado)
resource "aws_cloudwatch_log_group" "cloudhsm" {
  count             = var.enable_cloudwatch_logs ? 1 : 0
  name              = "/aws/cloudhsm/${local.cluster_name}"
  retention_in_days = var.log_retention_days

  tags = merge(local.tags, {
    Name = "${local.cluster_name}-logs"
  })
}

# IAM Role para CloudHSM Service
resource "aws_iam_role" "cloudhsm_service" {
  name_prefix = "${local.cluster_name}-service-role"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "cloudhsm.amazonaws.com"
        }
      }
    ]
  })

  tags = local.tags
}

# IAM Policy para CloudHSM Service
resource "aws_iam_role_policy" "cloudhsm_service" {
  name_prefix = "${local.cluster_name}-service-policy"
  role        = aws_iam_role.cloudhsm_service.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:CreateNetworkInterface",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DetachNetworkInterface",
          "ec2:DeleteNetworkInterface",
          "ec2:AttachNetworkInterface",
          "ec2:ModifyNetworkInterfaceAttribute",
          "ec2:DescribeSubnets",
          "ec2:DescribeVpcs"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams"
        ]
        Resource = var.enable_cloudwatch_logs ? aws_cloudwatch_log_group.cloudhsm[0].arn : "*"
      }
    ]
  })
}