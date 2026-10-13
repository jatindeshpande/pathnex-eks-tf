resource "aws_eks_cluster" "pathnex" {
  name     = var.cluster_name
  role_arn = "arn:aws:iam::861142265676:role/AmazonEKSClusterRole-Pathnex"
  version  = "1.35"

  upgrade_policy {
    support_type = "STANDARD"
  }

  access_config {
    authentication_mode = "API_AND_CONFIG_MAP"
  }

  vpc_config {
    subnet_ids = [
      "subnet-0f201fd5ad1b2a6da",
      "subnet-04c702aef95684b9b",
      "subnet-00d71d876937cb0fb"
    ]

    security_group_ids = [
      "sg-0eb804e9e40aca084"
    ]

    endpoint_public_access  = true
    endpoint_private_access = true

    public_access_cidrs = [
      "0.0.0.0/0"
    ]
  }
  zonal_shift_config {
         enabled = false
        }
}

resource "aws_eks_access_entry" "devops" {
  cluster_name  = aws_eks_cluster.pathnex.name
  principal_arn = "arn:aws:iam::861142265676:role/AWS-DevOps-Role"
  type          = "STANDARD"
}

resource "aws_eks_access_policy_association" "devops_admin" {
  cluster_name  = aws_eks_cluster.pathnex.name
  principal_arn = aws_eks_access_entry.devops.principal_arn

  policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"

  access_scope {
    type = "cluster"
  }
}

resource "aws_ecr_repository" "app_repo" {
  name = "pathnex-ecr"
  image_scanning_configuration {
    scan_on_push = true
  }
  force_delete = true
}

output "ecr_repository_url" {
  description = "ECR repository URL for the application"
  value       = aws_ecr_repository.app_repo.repository_url
}