locals {
  state_bucket_and_table_name = "${var.project_name}-${data.aws_region.current.name}-tfstate"
}

resource "aws_dynamodb_table" "state_lock_table" {
  name = "${local.state_bucket_and_table_name}"
  read_capacity = "20"
  write_capacity = "20"
  hash_key = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

resource "aws_s3_bucket" "state_bucket" {
  bucket = "${local.state_bucket_and_table_name}"
  region = "${data.aws_region.current.name}"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = {
    Project = "${var.project_name}"
  }
}
