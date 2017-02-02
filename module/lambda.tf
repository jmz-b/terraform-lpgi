resource "aws_lambda_function" "handler" {
	function_name = "${var.name}-handler"
	runtime = "python2.7"
	handler = "main.handler"
	filename = "${path.module}/handler.zip"
	role = "${aws_iam_role.handler_role.arn}"
}

resource "aws_lambda_permission" "handler_apigateway_permission" {
	function_name = "${aws_lambda_function.handler.arn}"
	action = "lambda:InvokeFunction"
	statement_id = "AllowExecutionFromApiGateway"
	principal = "apigateway.amazonaws.com"
}
