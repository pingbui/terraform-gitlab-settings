output "group_id" {
  description = "The unique id assigned to the group by the GitLab server."
  value       = gitlab_group.this.id
}

output "projects" {
  description = "The output of projects."
  value       = [ for pr in gitlab_project.this:
    map(
      "id","${pr.id}", 
      "name","${pr.name}",
      "path_with_namespace","${pr.path_with_namespace}"
    ) 
  ] 
}

output "service_slack_ids" {
  description = "The ids assigned to service_slack of these projects by the GitLab server."
  value       = values(gitlab_service_slack.this)[*]["id"]
}

output "project_variable_ids" {
  description = "The ids assigned to project_variable of these projects by the GitLab server."
  value       = values(gitlab_project_variable.this)[*]["id"]
}