variable "name" {
	type = "string"
}

variable "stage" {
	type = "string"
	default = "latest"
}

variable "aws_region" {
	type = "string"
}

variable "aws_account_id" {
	type = "string"
}

variable "handler_environment_variables" {
	type = "map"
	default = {}
}
