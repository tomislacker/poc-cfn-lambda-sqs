AWS_PROFILE := personal
REGION := us-east-1

PWD := $(shell pwd)
STACK_NAME := $(shell basename $(PWD))

.PHONY : deploy
deploy :
	cfn-lint template.yaml
	aws cloudformation deploy \
		--profile $(AWS_PROFILE) \
		--region $(REGION) \
		--stack-name $(STACK_NAME) \
		--template-file template.yaml \
		--capabilities \
			CAPABILITY_IAM

.PHONY  : message
message :
	AWS_PROFILE=$(AWS_PROFILE) \
	REGION=$(REGION) \
	STACK_NAME=$(STACK_NAME) \
	./send_message.sh

.PHONY : test
test   : | deploy message
