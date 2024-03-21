data "kubectl_path_documents" "logging-file" {
  pattern = "./logging/*.yaml"
}

resource "kubectl_manifest" "sock_shop" {
  for_each  = toset(data.kubectl_path_documents.logging-file.documents)
  yaml_body = each.value
}