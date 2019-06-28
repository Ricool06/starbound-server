output "backend_bucket_name" {
  value = "${aws_s3_bucket.state_bucket.bucket}"
}

output "backend_table_name" {
  value = "${aws_dynamodb_table.state_lock_table.name}"
}

output "aws_region" {
  value = "${data.aws_region.current.name}"
}
