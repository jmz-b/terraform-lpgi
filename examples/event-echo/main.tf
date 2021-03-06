variable "aws_region" {
	type = "string"
}

variable "aws_account_id" {
	type = "string"
}

module "event_echo" {
	source = "github.com/jmz-b/terraform-lpgi/module"
	name = "event-echo"
	aws_account_id = "${var.aws_account_id}"
	aws_region = "${var.aws_region}"
}


output "proxy_rest_api_id" {
	value = "${module.event_echo.proxy_rest_api_id}"
}

output "handler_function_name" {
	value = "${module.event_echo.handler_function_name}"
}
