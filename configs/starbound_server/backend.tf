terraform {
  backend "s3" {
    bucket         = "starbound-server-eu-west-1-106887332414-tfstate"
    key            = "terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "starbound-server-eu-west-1-106887332414-tfstate"
  }
}