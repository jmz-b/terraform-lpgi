resource "aws_iam_role" "handler_role" {
	name = "${var.name}-handler"
	assume_role_policy = <<EOF
{
	"Version": "2012-10-17",
	"Statement": [
		{
			"Action": [
				"sts:AssumeRole"
			],
			"Principal": {
				"Service": "lambda.amazonaws.com"
			},
			"Effect": "Allow",
			"Sid": ""
		}
	]
}
	EOF
}
