provider "local" {}

resource "null_resource" "create_myfilename" {

  provisioner "local-exec" {
    command = "touch changeme_file.txt"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "rm -f changeme_file.txt"
  }
}