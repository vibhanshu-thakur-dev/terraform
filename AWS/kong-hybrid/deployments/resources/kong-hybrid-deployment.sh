openssl req -new -x509 -nodes -newkey ec:<(openssl ecparam -name secp384r1) \
  -keyout cert/cluster.key -out cert/cluster.crt \
  -days 1095 -subj "/CN=kong_clustering"


kubectl create namespace kong


kubectl create secret tls kong-cluster-cert -n kong --cert=cert/cluster.crt --key=cert/cluster.key


kubectl create secret generic kong-db-password \
  -n kong \
  --from-literal=postgresql-password=kong \
  --from-literal=postgresql-postgres-password=kong

helm upgrade -i my-kong-cp kong/kong -n kong --values kong-cp-values.yaml


helm upgrade -i my-kong-dp kong/kong -n kong --values kong-dp-values.yaml


# 
# 

image:
  repository: kong
  tag: "2.5"

env:
  role: control_plane
  cluster_cert: /etc/secrets/kong-cluster-cert/tls.crt
  cluster_cert_key: /etc/secrets/kong-cluster-cert/tls.key
  database: "postgres"
  pg_host: "kong-db-postgresql.kong.svc.cluster.local"
  pg_port: 5432
  pg_user: kong
  pg_password:
    valueFrom:
      secretKeyRef:
        name: kong-db-password
        key: postgresql-password

secretVolumes:
- kong-cluster-cert

cluster:
  enabled: true
  tls:
    enabled: true

admin:
  enabled: true
  http:
    enabled: true

proxy:
  enabled: false

ingressController:
  installCRDs: false
  env:
    publish_service: kong/my-kong-dp-kong-proxy


# 


env:
  database: "off"
  role: data_plane
  cluster_cert: /etc/secrets/kong-cluster-cert/tls.crt
  cluster_cert_key: /etc/secrets/kong-cluster-cert/tls.key
  cluster_control_plane: my-kong-cp-kong-cluster.kong.svc.cluster.local:8005

secretVolumes:
- kong-cluster-cert

image:
  repository: kong
  tag: "2.5"

ingressController:
  enabled: false
