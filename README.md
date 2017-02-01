# terraform-lpgi: lambda proxy gateway interface

this terraform module provides a transparent https gateway that will forward
all requests to an arbitary handler.

## components overview

* proxy (apigateway): an https host that uses a greedy path variable, the
  catch-all ANY method and lambda proxy integration to map all requests to a
  handler

* dist (s3): a storage bucket for request handler distributions

* handler (lambda): a lambda function which executes the request handler code
  when invoked with apigateway proxy integration

there is no routing, ie: a request to any path invokes the same handler code

## quick start example

this example will provision and deploy and example lpgi application.

the application will accept any request and echo it back to the user in the
form of a lambda proxy integration mapping object.

* provide user and project specific settings

```
export AWS_ACCESS_KEY_ID="XXXXXXXXXXXXXXXXXXXX"
export AWS_SECRET_ACCESS_KEY="XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
export AWS_DEFAULT_REGION="eu-west-1"

cat << EOF > terraform.tfvars
name = "echo"
aws_account_id = "xxxxxxxxxxxx"
aws_region = "eu-west-1"
EOF
```

* bootstrap

this is create all the component resources and provide a default request
handler.

```
terraform plan module
terraform apply module
```

* deploy new request handler

```
aws s3 cp examples/echo.zip s3://echo-dist/handler.zip

aws lambda update-function-code \
	--function-name 'echo-handler' \
	--s3-bucket 'echo-dist' \
	--s3-key 'handler.zip'
```

## request handler distribution format

a request handler distrubution is a zip file containing a file named `main.py`
at it's root, for example:

```
$ unzip -l examples/echo.zip
Archive:  examples/echo.zip
  Length      Date    Time    Name
---------  ---------- -----   ----
        0  2017-01-31 17:37   __init__.py
      115  2017-02-01 15:44   main.py
---------                     -------
      115                     2 files
```

`main.py` must be valid python code and define a function named `handler`

## handler function interface

with the lambda proxy integration, apigateway maps the entire client request to
the input request handler event parameter as follows:

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

the request handler must respond with an object in the following format:

```
{
	"statusCode": httpStatusCode,
	"headers": { "headerName": "headerValue", ... },
	"body": "..."
}
```

for example, here is the code for the default request handler

```
def handler(event, context):
    return {'statusCode': 404, 'headers': {}, 'body': 'nothing to see here'}
```

### relevant aws developer guides

* http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-set-up-simple-proxy.html
* http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-create-api-as-simple-proxy-for-http.html
* http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-create-api-as-simple-proxy-for-lambda.html
