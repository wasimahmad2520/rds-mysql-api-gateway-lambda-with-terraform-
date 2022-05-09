

/* zip the source code  */
data "archive_file" "init" {
  type        = var.type
  source_dir = var.source_dir
  output_path = var.output_path
  /* source_file = "${path.module}/index.js"
  output_path = "${path.module}/index.zip" */
}




