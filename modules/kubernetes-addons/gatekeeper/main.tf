locals {
  name      = try(var.helm_config.name, "gatekeeper")
  namespace = try(var.helm_config.namespace, "gatekeeper-system")
}

module "helm_addon" {
  source = "../helm-addon"

  manage_via_gitops = var.manage_via_gitops

  helm_config = merge({
    name             = local.name
    chart            = local.name
    version          = "3.9.0"
    repository       = "https://open-policy-agent.github.io/gatekeeper/charts"
    namespace        = local.namespace
    create_namespace = true
    force_update     = true
    description      = "GateKeeper helm Chart deployment configuration."
    # values = [templatefile("${path.module}/values.yaml", {
    #   aws_region     = var.addon_context.aws_region_name
    #   eks_cluster_id = var.addon_context.eks_cluster_id
    #   image_tag      = "v${var.eks_cluster_version}.0"
    # })]
    },
    var.helm_config
  )

  addon_context = var.addon_context
}
