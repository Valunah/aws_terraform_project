variable "user_data" {
  type = string

  default = <<-EOT
    #!/bin/bash
    sudo dnf install git-all
  EOT
}