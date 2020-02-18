provider "aws" {
	version = "> 1.23"
	region = "${var.aws_region}"
}

provider "aws" {
	version = "> 1.23"
	alias   = "cloudfront-acm-certs"
	region  = "us-east-1"
}

terraform {
	required_version = "> 0.10.6"

	backend "s3" {
		encrypt = true
		bucket = "terraform-state"
		dynamodb_table = "terraform-lock"
		region = "eu-west-1"
		key = "artifactory.tfstate"
	}
}
