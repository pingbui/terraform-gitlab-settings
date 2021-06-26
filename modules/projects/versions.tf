terraform {
  required_version = ">= 0.13.6"

  required_providers {
    gitlab = {
      source  = "gitlabhq/gitlab"
      version = ">= 3.3.0"
    }
  }
}