resource "kubernetes_namespace" "target" {
  metadata {
    name = var.cluster_proportional_autoscaler_config.namespace
  }
}

resource "helm_release" "cluster_proportional_autoscaler" {
  name       = "cluster-proportional-autoscaler"
  repository = "https://kubernetes.github.io/autoscaler"
  chart      = "cluster-autoscaler"

  namespace = var.cluster_proportional_autoscaler_config.namespace

  set {
    name  = "wait-for"
    value = aws_iam_role.service_account_role.arn
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com\\/role-arn"
    value = aws_iam_role.service_account_role.arn
  }



  set {
    name  = "autoDiscovery.clusterName"
    value = var.cluster_name
  }

  set {
    name  = "awsRegion"
    value = "eu-west-2"
  }

  set {
    name  = "rbac.serviceAccount.name"
    value = var.cluster_proportional_autoscaler_config.service_account_name
  }
  
 set {
    name  = "rbac.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.service_account_role.arn
  }
}