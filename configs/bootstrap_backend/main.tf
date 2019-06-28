module "bootstrap_backend" {
  source = "./../../modules/s3_backend"
  project_name = "starbound-server"
}

resource "null_resource" "backend_templater" {
  provisioner "local-exec" {
    command =<<EOF
      cd ../starbound_server && \
      BUCKET=${module.bootstrap_backend.backend_bucket_name} \
      DB_TABLE=${module.bootstrap_backend.backend_table_name} \
      REGION=${module.bootstrap_backend.aws_region} \
      bash -c 'envsubst < backend.tf.tmpl > backend.tf'
    EOF
  }
}
