variable "deploy_key" {
  description = "The deploy_key of projects in the group."
  type        = map(any)
  default     = {}
}

variable "project_id_for_key" {
  description = "The project id of this deploy key."
  type        = string
  default     = ""
}

variable "project_name_for_key" {
  description = "The project name of this deploy key."
  type        = string
  default     = ""
}

resource "gitlab_deploy_key" "this" {
  count = length(keys(var.deploy_key)) > 0 ? 1 : 0

  project  = var.project_id_for_key
  title    = lookup(var.deploy_key, "title")
  key      = lookup(var.deploy_key, "key")
  can_push = lookup(var.deploy_key, "can_push", true)
}

resource "gitlab_deploy_key_enable" "this" {
  for_each = length(keys(var.deploy_key)) > 0 ? { for pj in var.projects : pj.name => pj if pj.name != var.project_name_for_key } : {}

  project = [for ids in values(gitlab_project.this)[*] : ids.id if ids.name == lookup(each.value, "name")][0]
  key_id  = gitlab_deploy_key.this.*.id[0]
}

output "deploy_key_id" {
  description = "The unique id assigned to the deploy key."
  value       = gitlab_deploy_key.this.*.id[0]
}
