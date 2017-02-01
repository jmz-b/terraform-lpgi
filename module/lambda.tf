resource "aws_lambda_function" "handler" {
	function_name = "${var.name}-${var.stage}-handler"
	runtime = "python2.7"
	handler = "main.handler"
	s3_bucket = "${aws_s3_bucket_object.default_dist.bucket}"
	s3_key = "${aws_s3_bucket_object.default_dist.key}"
	role = "${aws_iam_role.handler_role.arn}"
	depends_on = [
		"aws_iam_role.handler_role",
		"aws_s3_bucket_object.default_dist"
	]
}

resource "aws_lambda_permission" "handler_apigateway_permission" {
	function_name = "${aws_lambda_function.handler.arn}"
	action = "lambda:InvokeFunction"
	statement_id = "AllowExecutionFromApiGateway"
	principal = "apigateway.amazonaws.com"
}
