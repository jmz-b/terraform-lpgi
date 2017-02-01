resource "aws_lambda_function" "handler" {
	depends_on = ["aws_iam_role.handler_role", "aws_s3_bucket_object.default_dist"]
	runtime = "python2.7"
	function_name = "${var.name}-handler"
	handler = "main.handler"
	s3_bucket = "${aws_s3_bucket_object.default_dist.bucket}"
	s3_key = "${aws_s3_bucket_object.default_dist.key}"
	role = "${aws_iam_role.handler_role.arn}"
}

resource "aws_lambda_permission" "handler_apigateway_permission" {
	function_name = "${aws_lambda_function.handler.arn}"
	action = "lambda:InvokeFunction"
	statement_id = "AllowExecutionFromApiGateway"
	principal = "apigateway.amazonaws.com"
}
