module "bootstrap_backend" {
  source = "github.com/Ricool06/bootstrap-s3-backend"
  project_name = "starbound-server"
  path_to_backend_template_file = "../starbound_server/backend.tf.tmpl"
}
