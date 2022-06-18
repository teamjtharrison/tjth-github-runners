variable "runner_name" {
  description = "Runner group name to be used in descriptions"
}

variable "instance_type" {
  description = "The instance type to use for the Github action runners"
  default     = "t2.micro"
}

