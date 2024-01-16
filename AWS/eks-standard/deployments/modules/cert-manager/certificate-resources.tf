resource "kubectl_manifest" "letsencrypt-cluster-issuer" {
  yaml_body = <<YAML
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-cert-issuer
spec:
  acme:
    email: vibhanshu@quadcorps.co.uk
    server: https://acme-v02.api.letsencrypt.org/directory
    privateKeySecretRef:
      name: letsencrypt-cert-issuer
    solvers:
      - selector:
          dnsZones: 
            - kong.eks.vt.dev.quaddemo.co.uk
            - monitoring.eks.vt.dev.quaddemo.co.uk
        # http01:
        #   ingress:
        #     ingressClassName: nginx
        dns01:
          route53:
            region: eu-west-2
            hostedZoneID: Z01950412AQ1SLPQP3SSO

 YAML

  depends_on = [helm_release.cert-manager]
}


resource "kubectl_manifest" "monitoring-certificate" {
  yaml_body = <<YAML
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: monitoring.eks.vt.dev.quaddemo.co.uk-certificate
spec:
  dnsNames:
  - monitoring.eks.vt.dev.quaddemo.co.uk
  issuerRef:
    kind: ClusterIssuer
    name: letsencrypt-cert-issuer
  privateKey:
    algorithm: RSA
    encoding: PKCS1
    size: 2048
  secretName: monitoring.eks.vt.dev.quaddemo.co.uk-certificate-secret
  usages:
  - server auth
  - client auth
 YAML

  depends_on = [helm_release.cert-manager, kubectl_manifest.letsencrypt-cluster-issuer]
}

resource "kubectl_manifest" "kong-certificate" {
  yaml_body = <<YAML
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: kong.eks.vt.dev.quaddemo.co.uk-certificate
spec:
  dnsNames:
  - kong.eks.vt.dev.quaddemo.co.uk
  issuerRef:
    kind: ClusterIssuer
    name: letsencrypt-cert-issuer
  privateKey:
    algorithm: RSA
    encoding: PKCS1
    size: 2048
  secretName: kong.eks.vt.dev.quaddemo.co.uk-certificate-secret
  usages:
  - server auth
  - client auth
 YAML

  depends_on = [helm_release.cert-manager, kubectl_manifest.letsencrypt-cluster-issuer]
}