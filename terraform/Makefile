TERRAFORM ?= terraform
PWSH ?= pwsh
AWS_PROFILE ?= terraform
AWS_SSO_SCRIPT ?= ./aws-sso.ps1

.PHONY: init fmt validate plan plan.pwsh apply apply.pwsh

init:
	$(TERRAFORM) init

fmt:
	$(TERRAFORM) fmt

validate:
	$(TERRAFORM) validate

plan:
	$(TERRAFORM) plan

plan.pwsh:
	$(PWSH) -NoProfile -ExecutionPolicy Bypass -Command ". $(AWS_SSO_SCRIPT); Set-AwsSsoEnv -ProfileName '$(AWS_PROFILE)' | Out-Null; $(TERRAFORM) plan"

apply:
	$(TERRAFORM) apply

apply.pwsh:
	$(PWSH) -NoProfile -ExecutionPolicy Bypass -Command ". $(AWS_SSO_SCRIPT); Set-AwsSsoEnv -ProfileName '$(AWS_PROFILE)' | Out-Null; $(TERRAFORM) apply"
