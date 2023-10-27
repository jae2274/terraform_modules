

variable "branch_map" {
  type = map(object({
    prefix = string
    env = string
  }))
}

variable "prefix_separator" {
  type = string
  default = "_"
}

data external git_branch{
  program = ["${path.module}/git_branch.sh"  ]
}

locals{
  branch = data.external.git_branch.result["branch"]
  is_key_existed = lookup(var.branch_map, local.branch, null) != null
  prefix = local.is_key_existed? var.branch_map[local.branch].prefix : local.branch
  env = local.is_key_existed? var.branch_map[local.branch].env : local.branch
}

output branch{
  value = local.branch
}

output "prefix" {
  value = length(local.prefix) > 0 ? "${local.prefix}${var.prefix_separator}" : ""
}

output "env" {
  value = local.env
}