

###############################################################
# CREATE IAM POLICY, ROLE AND ATTACHEMENT
###############################################################

resource "aws_iam_policy" "service_account_policy" {
  name        = "${var.cluster_name}-${var.certmanager_config.service_account_name}-policy"
  path        = "/"
  description = "Policy for K8 service account(cert manager) at ${var.cluster_name}/${var.certmanager_config.namespace}/${var.certmanager_config.service_account_name}. This policy should be bound to ${var.cluster_name}-${var.certmanager_config.service_account_name}-role"
  policy      = data.aws_iam_policy_document.iam_service_account_policy.json
  tags        = var.tags
}

resource "aws_iam_role" "service_account_role" {
  name               = "${var.cluster_name}-${var.certmanager_config.service_account_name}-role"
  description        = "Role for K8 service account(cert manager) at ${var.cluster_name}/${var.certmanager_config.namespace}/${var.certmanager_config.service_account_name}. This role will have ${var.cluster_name}-${var.certmanager_config.service_account_name}-policy"
  assume_role_policy = data.aws_iam_policy_document.iam_service_account_assume_role.json
  tags               = var.tags
}

resource "aws_iam_role_policy_attachment" "service_account_attach" {
  role       = aws_iam_role.service_account_role.name
  policy_arn = aws_iam_policy.service_account_policy.arn
}