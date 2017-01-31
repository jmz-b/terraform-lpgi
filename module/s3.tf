resource "aws_s3_bucket" "dist_bucket" {
	bucket = "${var.name}-dist"
	acl = "private"
	tags {
		Name = "${var.name}"
		Environment = "${var.stage}"
	}
}

resource "aws_s3_bucket_object" "default_dist_object" {
	depends_on = ["aws_s3_bucket.dist_bucket"]
	bucket = "${var.name}-dist"
	key = "${var.stage}.zip"
	source = "${path.module}/dist.zip"
	etag = "${md5(file("${path.module}/dist.zip"))}"
}

