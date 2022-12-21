resource "local_sensitive_file" "private_key" {
  content         = tls_private_key.stackstorm_generated_key.private_key_openssh
  filename        = local.filename
  file_permission = "0600"
}

resource "local_file" "ansible_inventory" {
  filename = format("%s/%s", abspath(path.root), "inventory.yaml")
  content = <<-EOT
bitops_servers:
 hosts:
   ${aws_instance.server.public_ip}
 vars:
   ansible_ssh_user: ubuntu
   ansible_ssh_private_key_file: ${local.filename}
   app_repo_name: ${var.app_repo_name}
   app_install_root: ${var.app_install_root}
   ansible_python_interpreter: /usr/bin/python3
  EOT
}

locals {
    filename = format("%s/%s/%s", abspath(path.root), ".ssh", "bitops-ssh-key.pem")
}

output "localfile_path" {
  description = "Filepath to local_file inventory.yaml"
  value       = local_file.ansible_inventory.filename
}
output "localfile_abspath" {
  description = "value of abspath(path.root)"
  value       = abspath(path.root)
}
output "inventory_yaml_output" {
  description = "contents of the local_file.ansible_inventory"
  value       = local_file.ansible_inventory.content
}
