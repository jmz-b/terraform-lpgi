event-echo
==========

example lpgi application. client requests will be mapped to the handlers event
input paramter and echoed back in the response body

config
------

```sh
cat << EOF > terraform.tfvars
aws_account_id = "xxxxxxxxxxxx"
aws_region = "eu-west-1"
EOF
```

bootstrap
---------

```sh
terraform get
terraform plan
terraform apply
```

build
-----

```sh
make
```

deploy
------

```sh
aws lambda update-function-code \
	--function-name "$(terraform output handler_function_name)" \
	--zip-file 'fileb://handler.zip'
```

test
----

```sh
curl https://$(terraform output proxy_rest_api_id).execute-api.eu-west-1.amazonaws.com/default
```
