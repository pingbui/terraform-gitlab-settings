variable "gitlab_token" {
  description = "The Token of Gitlab"
  type        = string
  default     = null
}

variable "gitlab_url" {
  description = "The URL of Gitlab API"
  type        = string
  default     = null
}

variable "group_settings" {
  description = "The settings of the project group."
  type        = map(any)
}

variable "projects" {
  description = "The list of the projects."
  type        = list(map(any))
  default     = []
}

variable "project_variable" {
  description = "The project variable of projects in the group."
  type        = map(any)
  default     = {}
}

variable "service_slack" {
  description = "The Slack notifications integration of projects in the group."
  type        = map(any)
  default     = {}
}