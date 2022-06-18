terraform {
  backend "s3" {
    bucket = "tjth-states-827047072822"
    key    = "tjth-tcoin.state"
    region = "eu-west-1"
  }
}
