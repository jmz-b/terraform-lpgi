# terraform-lpgi: lambda proxy gateway interface

this terraform module provides a transparent https gateway that will forward
all requests to an arbitary handler. there is no routing, ie: a request to any
path invokes the same handler code

## quick start

* provide user and project specific settings

```
export AWS_ACCESS_KEY_ID="XXXXXXXXXXXXXXXXXXXX"
export AWS_SECRET_ACCESS_KEY="XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
export AWS_DEFAULT_REGION="eu-west-1"

cat << EOF > terraform.tfvars
name = "lpgi-app"
stage = "dev"
aws_account_id = "xxxxxxxxxxxx"
aws_region = "eu-west-1"
EOF
```

* bootstrap

```
terraform plan module
terraform apply module
```

## details

### overview of components

* apigateway: proxy

an https host that uses a greedy path variable, the catch-all ANY method and
lambda proxy integration to map all requests to a handler

* s3 bucket: dist

storage for zip files containing request handler code

* lambda: handler

a function which will be invoked by apigateway using lambda proxy integrations
and execute request handler code stored on s3

### writing custom handlers

with lambda proxy integration, apigateway maps the entire client request to the
input event parameter of the request handler as follows:

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

the request handler must return an object of the following format:

```
{
    "statusCode": httpStatusCode,
    "headers": { "headerName": "headerValue", ... },
    "body": "..."
}
```

### relevant aws developer guides

* http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-set-up-simple-proxy.html
* http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-create-api-as-simple-proxy-for-http.html
* http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-create-api-as-simple-proxy-for-lambda.htm l
