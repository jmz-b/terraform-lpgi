variable "aws_region" {
	type = "string"
}

variable "aws_account_id" {
	type = "string"
}

module "echo" {
	source = "github.com/jmz-b/terraform-lpgi/module"
	name = "echo"
	aws_account_id = "${var.aws_account_id}"
	aws_region = "${var.aws_region}"
}
