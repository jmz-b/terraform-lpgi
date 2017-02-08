resource "aws_iam_policy" "allow_logging" {
	name = "allow_logging"
	policy = <<EOF
{
	"Version": "2012-10-17",
	"Statement": [
		{
			"Effect": "Allow",
			"Action": [
				"logs:CreateLogGroup",
				"logs:CreateLogStream",
				"logs:PutLogEvents",
				"logs:DescribeLogStreams"
		],
			"Resource": [
				"arn:aws:logs:*:*:*"
		]
	}
	]
}
		EOF
}

resource "aws_iam_policy_attachment" "grant_logging" {
	name = "lambda_policy_attachment"
	roles = ["${module.event_logger.handler_role_name}"]
	policy_arn = "${aws_iam_policy.allow_logging.arn}"
}
