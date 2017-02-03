variable "aws_region" {
	type = "string"
}

variable "aws_account_id" {
	type = "string"
}

module "directions" {
	source = "github.com/jmz-b/terraform-lpgi/module"
	name = "directions"
	aws_account_id = "${var.aws_account_id}"
	aws_region = "${var.aws_region}"
}


output "proxy_rest_api_id" {
	value = "${module.directions.proxy_rest_api_id}"
}

output "handler_function_name" {
	value = "${module.directions.handler_function_name}"
}
