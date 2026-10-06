resource "aws_eks_node_group" "pathnex-NG" {
  cluster_name    = aws_eks_cluster.pathnex.name
  node_group_name = "pathnex-ng"

  node_role_arn = "arn:aws:iam::861142265676:role/AmazonEKSClusterRole-Pathnex"

  subnet_ids = [
    "subnet-0f201fd5ad1b2a6da",
    "subnet-04c702aef95684b9b",
    "subnet-00d71d876937cb0fb"
  ]

  version        = "1.35"
  ami_type       = "AL2023_x86_64_STANDARD"
  capacity_type  = "SPOT"
  instance_types = ["t3.small"]
  disk_size      = 20

  scaling_config {
    desired_size = 1
    min_size     = 1
    max_size     = 2
  }

  tags = {
  "k8s.io/cluster-autoscaler/enabled"          = "true"
  "k8s.io/cluster-autoscaler/Pathnex-Sep-2026" = "owned"
  }
  
  lifecycle {
  ignore_changes = [
    scaling_config[0].desired_size
  ]
  }



  update_config {
    max_unavailable = 1
    update_strategy = "DEFAULT"
  }

  remote_access {
    ec2_ssh_key = "Devops-KeyPair.pem"

    source_security_group_ids = [
      "sg-0eb804e9e40aca084"
    ]
  }
}
