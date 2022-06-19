terraform {
  backend "s3" {
    bucket = "tjth-states-827047072822"
    key    = "tjth-github-runners.state"
    region = "eu-west-1"
  }
}
