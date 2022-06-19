module "tjth_runner" {
  # source = "git@github.com:tjtharrison/tjth-github-runners.git//modules/runner?ref=1.0.0"
  source          = "./modules/runner"
  runner_name     = "default"
  github_team_url = "https://github.com/tjtharrison/tcoin"
}
