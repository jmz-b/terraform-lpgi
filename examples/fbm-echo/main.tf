variable "aws_region" {
	type = "string"
}

variable "aws_account_id" {
	type = "string"
}

variable "fbm_verify_token" {
	type = "string"
}

module "echo_fbm" {
	source = "github.com/jmz-b/terraform-lpgi/module"
	name = "echo-fbm"
	aws_account_id = "${var.aws_account_id}"
	aws_region = "${var.aws_region}"
	handler_environment_variables = {
		fbm_verify_token = "${var.fbm_verify_token}"
	}
}

output "proxy_rest_api_id" {
	value = "${module.echo_fbm.proxy_rest_api_id}"
}

output "handler_function_name" {
	value = "${module.echo_fbm.handler_function_name}"
}
