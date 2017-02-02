output "proxy_rest_api_id" {
	value = "${aws_api_gateway_rest_api.proxy.id}"
}

output "handler_function_name" {
	value = "${aws_lambda_function.handler.function_name}"
}

output "handler_function_arn" {
	value = "${aws_lambda_function.handler.arn}"
}

output "handler_role_name" {
	value = "${aws_iam_role.handler_role.name}"
}

output "handler_role_arn" {
	value = "${aws_iam_role.handler_role.arn}"
}
