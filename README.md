lambda proxy gateway interface terraform module
===============================================

a terraform module to provide a transparent https proxy that will forward all
requests to a python handler

this module creates the following resources

 - proxy (apigateway): `rest_api` resource that maps client requests to the
  handlers event parameter. utilizes using a greedy path variable, the
  catch-all ANY method and lambda proxy integration.

 - handler (lambda): `python27` lambda function invoked by the proxy. the
  default handler always returns a `404` integration response

module input variables
----------------------

 - `name`
 - `aws_account_id`
 - `aws_region`

module usage
------------

```js
module "<app-name>" {
	source = "github.com/jmz-b/terraform-lpgi/module"
	name = "<app-name>"
	aws_account_id = "<app-aws-account-id>"
	aws_region = "<app-aws-region>"
}
```

outputs
-------

 - `proxy_rest_api_id`
 - `handler_function_name`
 - `handler_function_arn`
 - `handler_role_name`
 - `handler_role_arn`

lamba proxy gateway interface handlers
======================================

the default handler lambda function code can be replaced by updating it with a
new handler archive

for example using aws cli:

```sh
aws lambda update-function-code --function-name '<app-name>-handler' --zip-file 'fileb://<app-handler>.zip'
```

handler archive format
----------------------

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

functional interface
--------------------

with lambda proxy integration, apigateway maps the entire client request to
the input event parameter as follows:

```js
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

```js
{
	"statusCode": httpStatusCode,
	"headers": { "headerName": "headerValue", ... },
	"body": "..."
}
```

additional resources
--------------------

 - see the `examples` directory for more infomation on developing request
   handlers usings this module
 - http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-set-up-simple-proxy.html
 - http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-create-api-as-simple-proxy-for-http.html
 - http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-create-api-as-simple-proxy-for-lambda.html
