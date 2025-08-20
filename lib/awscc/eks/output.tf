output "cluster_endpoint" {
  description = "EKS cluster endpoint"
  value       = awscc_eks_cluster.this.endpoint
}
output "cluster_arn" {
  description = "EKS cluster ARN"
  value       = awscc_eks_cluster.this.arn
}
output "cluster_sg_id" {
  description = "Control plane security group ID"
  value       = awscc_security_group.eks_cluster.id
}
output "node_sg_id" {
  description = "Worker nodes security group ID"
  value       = awscc_security_group.eks_nodes.id
}
output "kubeconfig" {
  description = "Kubeconfig for cluster"
  value = <<-EOF
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: ${awscc_eks_cluster.this.certificate_authority[0].data}
    server: ${awscc_eks_cluster.this.endpoint}
  name: ${var.cluster_name}
contexts:
- context:
    cluster: ${var.cluster_name}
    user: ${var.cluster_name}-user
  name: ${var.cluster_name}
current-context: ${var.cluster_name}
kind: Config
preferences: {}
users:
- name: ${var.cluster_name}-user
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1alpha1
      command: aws
      args:
        - "eks"
        - "get-token"
        - "--cluster-name"
        - "${var.cluster_name}"
      env: []
EOF
}