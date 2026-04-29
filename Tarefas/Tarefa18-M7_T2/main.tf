terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
}

resource "aws_organizations_organization" "org" {
  feature_set = "ALL"
}

data "aws_caller_identity" "current" {
  id = "123456789012"
}

resource "aws_dynamodb_table" "tf_notes_table" {
  name           = "tf-notes-table"
  billing_mode   = "PROVISIONED"
  read_capacity  = 30
  write_capacity = 30

  attribute {
    name = "noteId"
    type = "S"
  }
  hash_key = "noteId"
}