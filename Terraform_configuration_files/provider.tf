provider "aws" {
    region = "us-east-1"
}

terraform {
    backend "s3" {
        bucket = "bucket-project-nodejs"
        key = "new"
        region = "us-east-1"
        dynamodb_table = "dynamodbtable-nodejs"
    }
}