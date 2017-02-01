# terraform-lpgi: lambda proxy gateway interface

this terraform module provides a transparent https gateway that will forward
all requests to an arbitary handler.

## overview

* proxy (apigateway): an https host that uses a greedy path variable, the
  catch-all ANY method and lambda proxy integration to map all requests to a
  handler

* dist (s3): a storage bucket for request handler code

* handler (lambda): a lambda function which executes the request handler code
  when invoked with apigateway proxy integration

there is no routing, ie: a request to any path invokes the same handler code

## quick start

* provide user and project specific settings

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

* bootstrap

```
terraform plan module
terraform apply module
```

* deploy a request handler

```

```

### relevant aws developer guides

* http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-set-up-simple-proxy.html
* http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-create-api-as-simple-proxy-for-http.html
* http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-create-api-as-simple-proxy-for-lambda.html
