# AWS Terraform Project: terraform-aws-vpc-k8-kong

This Terraform project is designed to deploy an Amazon Elastic Kubernetes Service (EKS) cluster, and Virtual Private Cloud (VPC) infrastructure on Amazon Web Services (AWS). It enables you to set up a highly scalable and secure environment for hosting containerized applications with Kong as the API Gateway.

## Prerequisites

Before you begin, make sure you have the following prerequisites in place:

- [Terraform](https://www.terraform.io/downloads.html) installed on your local machine.
- AWS CLI configured with appropriate access keys and permissions.
- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/) installed for managing the Kubernetes cluster.
- A basic understanding of AWS, Kubernetes, and Terraform.
- Have AWS profile setup in the machine with right set of credentials

## Services Created

- AWS VPC
  - With data, public and private subnets
  - Internet and Nat Gateways
- EKS Cluster
  - With CNI plugin
- Services Deployment
  - Kube monitoring stack - Prometheus, Grafana etc
  - Metric server
  - Flux CD
  - External DNS
  - Cert manager
  - Cluster autoscaler
  - Nginx ingress for montoring stack

## Usage

1. **Clone the Repository:**

   ```bash
   git clone https://github.com/vibhanshu-thakur-dev/terraform-aws-vpc-k8-kong/tree/main
   cd terraform-aws-vpc-k8-kong/AWS/eks-standard/environment
   terraform init
   terraform apply --var-file properties/<your-var-file>.tfvars
