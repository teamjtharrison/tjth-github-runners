variable "runner_name" {
  description = "Runner group name to be used in descriptions"
}

variable "instance_type" {
  description = "The instance type to use for the Github action runners"
  default     = "t2.micro"
}

variable "github_team_url" {
  description = "The team to which to attach the github runner"
}
