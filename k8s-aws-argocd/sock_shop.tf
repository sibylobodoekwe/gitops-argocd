data "kubectl_path_documents" "sock-shop-file" {
  pattern = "./deploy/kubernetes-iaac-microservice/manifests/*.yaml"
}

resource "kubectl_manifest" "sock-shop" {
  for_each  = toset(data.kubectl_path_documents.kubernetes-iaac-microservice-file.documents)
  yaml_body = each.value
}