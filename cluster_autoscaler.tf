resource "helm_release" "cluster_autoscaler" {
  name       = "cluster-autoscaler"
  namespace  = "kube-system"

  repository = "https://kubernetes.github.io/autoscaler"
  chart      = "cluster-autoscaler"

  values = [
    yamlencode({
      autoDiscovery = {
        clusterName = aws_eks_cluster.pathnex.name
      }

      awsRegion     = "us-east-2"
      cloudProvider = "aws"

      rbac = {
        serviceAccount = {
          create = true
          name   = "cluster-autoscaler"
        }
      }
    })
  ]

  depends_on = [
    aws_eks_pod_identity_association.cluster_autoscaler
  ]
}
