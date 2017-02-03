echo-fbm
=========

example lpgi application. implements a facebook messenger webhook and echos
messages back to the client.

config
------

```sh
cat << EOF > terraform.tfvars
fbm_verify_token = "xxxxxxxxxxx"
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
	--zip-file 'fileb://handler.zip' \
```
