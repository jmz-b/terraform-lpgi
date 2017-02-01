# terraform-lpgi: lambda proxy gateway interface

this terraform module provides a transparent https gateway that will forward
all requests to an arbitary python handler

## components overview

* proxy (apigateway): https gateway using a greedy path variable, the catch-all
  ANY method and lambda proxy integration

* handler (lambda): python function invoked by apigateway proxy

* dist (s3): storage bucket for handler distributions

there is no routing, ie: a request to any path invokes the same handler code

## quick start example

provide user and project specific settings

```
export AWS_ACCESS_KEY_ID="XXXXXXXXXXXXXXXXXXXX"
export AWS_SECRET_ACCESS_KEY="XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
export AWS_DEFAULT_REGION="eu-west-1"

cat << EOF > terraform.tfvars
name = "<app-name>"
aws_account_id = "xxxxxxxxxxxx"
aws_region = "eu-west-1"
EOF
```

create all the component resources and provide a default request handler.

```
terraform plan module
terraform apply module
```

## handlers

the default handler can be replaced by building a new handler distribution,
uploading it to s3 and updating the handler lambda function

### handler distibution format

```
$ unzip -l module/handler.zip
Archive:  module/handler.zip
  Length      Date    Time    Name
---------  ---------- -----   ----
        0  2017-01-31 17:37   __init__.py
      106  2017-01-31 18:03   main.py
---------                     -------
      106                     2 files

```

`main.py` must be valid python code and define a top-level function named
`handler`

for example, here is the source of the default request handler's `main.py`

```
def handler(event, context):
    return {'statusCode': 404, 'headers': {}, 'body': 'nothing to see here'}
```

### functional interface

with lambda proxy integration, apigateway maps the entire client request to
the input event parameter as follows:

```
{
	"resource": "Resource path",
	"path": "Path parameter",
	"httpMethod": "Incoming request's method name"
	"headers": {Incoming request headers}
	"queryStringParameters": {query string parameters }
	"pathParameters":  {path parameters}
	"stageVariables": {Applicable stage variables}
	"requestContext": {Request context, including authorizer-returned key-value pairs}
	"body": "A JSON string of the request payload."
	"isBase64Encoded": "A boolean flag to indicate if the applicable request payload is Base64-encode"
}

```

the handler must respond with an object in the following format:

```
{
	"statusCode": httpStatusCode,
	"headers": { "headerName": "headerValue", ... },
	"body": "..."
}
```

### deploying

```
aws s3 cp handler.zip s3://<app-name>-dist/handler.zip
aws lambda update-function-code --function-name '<app-name>-handler' --s3-bucket '<app-name>-dist' --s3-key 'handler.zip'
```

## relevant aws developer guides

* http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-set-up-simple-proxy.html
* http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-create-api-as-simple-proxy-for-http.html
* http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-create-api-as-simple-proxy-for-lambda.html
