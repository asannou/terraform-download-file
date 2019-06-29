variable "aws_region" {
  type = "string"
}

provider "aws" {
  region = "${var.aws_region}"
}

resource "aws_s3_bucket" "test" {
  acl = "private"
  force_destroy = true
}

module "example" {
  source = "github.com/asannou/terraform-download-file"
  url = "https://example.com"
}

resource "aws_s3_bucket_object" "example" {
  bucket = "${aws_s3_bucket.test.bucket}"
  key = "example"
  content = "${module.example.content}"
  etag = "${md5(module.example.content)}"
}

module "example2" {
  source = "github.com/asannou/terraform-download-file"
  url = "https://www.terraform.io"
}

resource "aws_s3_bucket_object" "example2" {
  bucket = "${aws_s3_bucket.test.bucket}"
  key = "example2"
  source = "${module.example2.filename}"
  etag = "${filemd5(module.example2.filename)}"
}

