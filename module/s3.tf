resource "aws_s3_bucket" "dist_bucket" {
	bucket = "${var.name}-dist"
	acl = "private"
}

resource "aws_s3_bucket_object" "default_dist" {
	key = "${var.name}-dist.zip"
	bucket = "${var.name}-dist"
	source = "${path.module}/dist.zip"
	etag = "${md5(file("${path.module}/dist.zip"))}"
	depends_on = ["aws_s3_bucket.dist_bucket"]
}
