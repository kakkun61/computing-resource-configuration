TERRAFORM ?= terraform
PWSH ?= pwsh
AWS_PROFILE ?= terraform
AWS_SSO_SCRIPT ?= ./aws-sso.ps1

.PHONY: init fmt validate plan apply

init:
	$(TERRAFORM) init

fmt:
	$(TERRAFORM) fmt

validate:
	$(TERRAFORM) validate

plan:
	$(PWSH) -NoProfile -ExecutionPolicy Bypass -Command ". $(AWS_SSO_SCRIPT); Set-AwsSsoEnv -ProfileName '$(AWS_PROFILE)' | Out-Null; $(TERRAFORM) plan"

apply:
	$(PWSH) -NoProfile -ExecutionPolicy Bypass -Command ". $(AWS_SSO_SCRIPT); Set-AwsSsoEnv -ProfileName '$(AWS_PROFILE)' | Out-Null; $(TERRAFORM) apply"
