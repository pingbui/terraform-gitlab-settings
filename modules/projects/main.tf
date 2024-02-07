provider "gitlab" {
  token    = var.gitlab_token
  base_url = var.gitlab_url
}

resource "gitlab_group" "this" {
  name                              = lookup(var.group_settings, "name")
  path                              = lookup(var.group_settings, "path")
  description                       = lookup(var.group_settings, "description", null)
  lfs_enabled                       = lookup(var.group_settings, "lfs_enabled", true)
  request_access_enabled            = lookup(var.group_settings, "request_access_enabled", false)
  visibility_level                  = lookup(var.group_settings, "visibility_level", "private")
  share_with_group_lock             = lookup(var.group_settings, "share_with_group_lock", false)
  project_creation_level            = lookup(var.group_settings, "project_creation_level", "maintainer")
  auto_devops_enabled               = lookup(var.group_settings, "auto_devops_enabled", false)
  emails_disabled                   = lookup(var.group_settings, "emails_disabled", false)
  mentions_disabled                 = lookup(var.group_settings, "mentions_disabled", false)
  subgroup_creation_level           = lookup(var.group_settings, "subgroup_creation_level", "owner")
  require_two_factor_authentication = lookup(var.group_settings, "require_two_factor_authentication", false)
  two_factor_grace_period           = lookup(var.group_settings, "two_factor_grace_period", 48)
  parent_id                         = lookup(var.group_settings, "parent_id", null)
}

resource "gitlab_project" "this" {
  for_each = { for pj in var.projects : pj.name => pj }

  name                                             = lookup(each.value, "name")
  path                                             = lookup(each.value, "path", null)
  namespace_id                                     = gitlab_group.this.id
  description                                      = lookup(each.value, "description", null)
  default_branch                                   = lookup(each.value, "default_branch", null)
  lfs_enabled                                      = lookup(each.value, "lfs_enabled", true)
  tags                                             = lookup(each.value, "tags", null) == null ? null : split(",", lookup(each.value, "tags"))
  request_access_enabled                           = lookup(each.value, "request_access_enabled", false)
  issues_enabled                                   = lookup(each.value, "issues_enabled", null)
  merge_requests_enabled                           = lookup(each.value, "merge_requests_enabled", null)
  pipelines_enabled                                = lookup(each.value, "pipelines_enabled", null)
  approvals_before_merge                           = lookup(each.value, "approvals_before_merge", 0)
  wiki_enabled                                     = lookup(each.value, "wiki_enabled", null)
  snippets_enabled                                 = lookup(each.value, "snippets_enabled", null)
  container_registry_enabled                       = lookup(each.value, "container_registry_enabled", null)
  merge_method                                     = lookup(each.value, "merge_method", "merge")
  visibility_level                                 = lookup(each.value, "visibility_level", "private")
  only_allow_merge_if_pipeline_succeeds            = lookup(each.value, "only_allow_merge_if_pipeline_succeeds", null)
  only_allow_merge_if_all_discussions_are_resolved = lookup(each.value, "only_allow_merge_if_all_discussions_are_resolved ", null)
  shared_runners_enabled                           = lookup(each.value, "shared_runners_enabled ", null)
  archived                                         = lookup(each.value, "archived", null)
  initialize_with_readme                           = lookup(each.value, "initialize_with_readme", null)
  packages_enabled                                 = lookup(each.value, "packages_enabled ", null)
  template_name                                    = lookup(each.value, "template_name", null)
  template_project_id                              = lookup(each.value, "template_project_id", null)
  use_custom_template                              = lookup(each.value, "use_custom_template", null)
  group_with_project_templates_id                  = lookup(each.value, "group_with_project_templates_id", null)
  pages_access_level                               = lookup(each.value, "pages_access_level", "private")
}

resource "gitlab_project_variable" "this" {
  for_each = length(keys(var.project_variable)) > 0 ? { for pj in var.projects : pj.name => pj } : {}

  project           = [for ids in values(gitlab_project.this)[*] : ids.id if ids.name == lookup(each.value, "name")][0]
  key               = lookup(var.project_variable, "key")
  value             = lookup(var.project_variable, "value")
  variable_type     = lookup(var.project_variable, "variable_type", "env_var")
  masked            = lookup(var.project_variable, "masked", false)
  environment_scope = lookup(var.project_variable, "environment_scope", "*")
}

resource "gitlab_service_slack" "this" {
  for_each = length(keys(var.service_slack)) > 0 ? { for pj in var.projects : pj.name => pj } : {}

  project                      = [for ids in values(gitlab_project.this)[*] : ids.id if ids.name == lookup(each.value, "name")][0]
  webhook                      = lookup(var.service_slack, "webhook")
  username                     = lookup(var.service_slack, "username", null)
  push_events                  = lookup(var.service_slack, "push_events", null)
  push_channel                 = lookup(var.service_slack, "push_channel", null)
  notify_only_broken_pipelines = lookup(var.service_slack, "notify_only_broken_pipelines", null)
  branches_to_be_notified      = lookup(var.service_slack, "branches_to_be_notified", "all")
  issues_events                = lookup(var.service_slack, "issues_events", null)
  issue_channel                = lookup(var.service_slack, "issue_channel", null)
  confidential_issues_events   = lookup(var.service_slack, "confidential_issues_events", null)
  confidential_issue_channel   = lookup(var.service_slack, "confidential_issue_channel", null)
  merge_requests_events        = lookup(var.service_slack, "merge_requests_events", null)
  merge_request_channel        = lookup(var.service_slack, "merge_request_channel", null)
  tag_push_events              = lookup(var.service_slack, "tag_push_events", null)
  tag_push_channel             = lookup(var.service_slack, "tag_push_channel", null)
  note_events                  = lookup(var.service_slack, "note_events", null)
  note_channel                 = lookup(var.service_slack, "note_channel", null)
  confidential_note_events     = lookup(var.service_slack, "confidential_note_events", null)
  pipeline_events              = lookup(var.service_slack, "pipeline_events", null)
  pipeline_channel             = lookup(var.service_slack, "pipeline_channel", null)
  wiki_page_events             = lookup(var.service_slack, "wiki_page_events", null)
  wiki_page_channel            = lookup(var.service_slack, "wiki_page_channel", null)
}