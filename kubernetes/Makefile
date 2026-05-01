NODE ?= node
HELM_YAML_GENERATOR := ./dev/create-helm-using-yaml.js
GENERATED_HELM_YAMLS := cloud-native-pg.yaml immich.yaml nfs-subdir-external-provisioner.yaml pdfding.yaml traefik.yaml

.PHONY: all
all: $(GENERATED_HELM_YAMLS)

%.yaml: %.template.yaml %.helm-values.yaml $(HELM_YAML_GENERATOR)
	$(NODE) $(HELM_YAML_GENERATOR) $< $(word 2,$^) $@
