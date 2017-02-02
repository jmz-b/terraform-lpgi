echo
====

example lpgi application. client requests will be mapped to the handlers event
input paramter and echoed back in the response body

config
------

```
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
aws lambda update-function-code --function-name 'echo-handler' --zip-file 'fileb://handler.zip'
```
