variable "url" {
  type = "string"
}

resource "random_id" "tempfile" {
  keepers = {
    url = "${var.url}"
  }
  prefix = ".temp."
  byte_length = 12
}

locals {
  tempfile = "${path.module}/${random_id.tempfile.b64}"
}

resource "null_resource" "tempfile" {
  triggers {
    always = "${timestamp()}"
  }
  provisioner "local-exec" {
    command = "curl -s -L -o \"${local.tempfile}\" \"${var.url}\""
  }
}

data "local_file" "temp" {
  depends_on = ["null_resource.tempfile"]
  filename = "${local.tempfile}"
}

data "template_file" "tempfile" {
  depends_on = ["null_resource.tempfile"]
  template = "${local.tempfile}"
}

output "content" {
  value = "${data.local_file.temp.content}"
}

output "filename" {
  value = "${data.template_file.tempfile.rendered}"
}

