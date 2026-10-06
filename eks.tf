resource "aws_eks_cluster" "pathnex" {
  name     = "Pathnex-Sep-2026"
  role_arn = "arn:aws:iam::861142265676:role/AmazonEKSClusterRole-Pathnex"
  version  = "1.35"

  upgrade_policy {
    support_type = "STANDARD"
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
