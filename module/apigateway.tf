resource "aws_api_gateway_rest_api" "proxy" {
	name = "${var.name}-proxy"
}

# root resource

resource "aws_api_gateway_method" "proxy_root_methods" {
	http_method = "ANY"
	authorization = "NONE"
	rest_api_id = "${aws_api_gateway_rest_api.proxy.id}"
	resource_id = "${aws_api_gateway_rest_api.proxy.root_resource_id}"
}

resource "aws_api_gateway_integration" "proxy_root_handler_integration" {
	type = "AWS_PROXY"
	integration_http_method = "POST"
	rest_api_id = "${aws_api_gateway_rest_api.proxy.id}"
	resource_id = "${aws_api_gateway_rest_api.proxy.root_resource_id}"
	http_method = "${aws_api_gateway_method.proxy_root_methods.http_method}"
	uri = "arn:aws:apigateway:${var.aws_region}:lambda:path/2015-03-31/functions/arn:aws:lambda:${var.aws_region}:${var.aws_account_id}:function:${aws_lambda_function.handler.function_name}/invocations"
}

# child resources

resource "aws_api_gateway_resource" "proxy_greedy_resource" {
	rest_api_id = "${aws_api_gateway_rest_api.proxy.id}"
	parent_id = "${aws_api_gateway_rest_api.proxy.root_resource_id}"
	path_part = "{proxy+}"
}

resource "aws_api_gateway_method" "proxy_greedy_methods" {
	http_method = "ANY"
	authorization = "NONE"
	rest_api_id = "${aws_api_gateway_rest_api.proxy.id}"
	resource_id = "${aws_api_gateway_resource.proxy_greedy_resource.id}"
}

resource "aws_api_gateway_integration" "proxy_greedy_handler_integration" {
	type = "AWS_PROXY"
	integration_http_method = "POST"
	rest_api_id = "${aws_api_gateway_rest_api.proxy.id}"
	resource_id = "${aws_api_gateway_resource.proxy_greedy_resource.id}"
	http_method = "${aws_api_gateway_method.proxy_greedy_methods.http_method}"
	uri = "arn:aws:apigateway:${var.aws_region}:lambda:path/2015-03-31/functions/arn:aws:lambda:${var.aws_region}:${var.aws_account_id}:function:${aws_lambda_function.handler.function_name}/invocations"
}

# deploy

resource "aws_api_gateway_deployment" "proxy_deployment" {
	rest_api_id= "${aws_api_gateway_rest_api.proxy.id}"
	stage_name = "default"
	variables = {}
	depends_on = [
		"aws_api_gateway_integration.proxy_root_handler_integration",
		"aws_api_gateway_integration.proxy_greedy_handler_integration",
	]
}
