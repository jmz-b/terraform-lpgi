OSRM directions
==========

OSRM routing engine example.

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
curl https://$(terraform output proxy_rest_api_id).execute-api.eu-west-1.amazonaws.com/latest?route=13.388860,52.517037+13.385983,52.496891
```

should return a JSON GPS route with navigation instructions for a route in Germany. 
