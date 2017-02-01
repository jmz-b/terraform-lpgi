resource "aws_s3_bucket" "dist_bucket" {
	bucket = "${var.name}-dist"
	acl = "private"
}

resource "aws_s3_bucket_object" "default_dist" {
	key = "handler.zip"
	bucket = "${var.name}-dist"
	source = "${path.module}/handler.zip"
	etag = "${md5(file("${path.module}/handler.zip"))}"
	depends_on = ["aws_s3_bucket.dist_bucket"]
}
