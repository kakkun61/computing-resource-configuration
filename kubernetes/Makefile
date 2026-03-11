.PHONY: all
all: cloud-native-pg.yaml immich.yaml nfs-subdir-external-provisioner.yaml pdfding.yaml

cloud-native-pg.yaml: cloud-native-pg.template.yaml cloud-native-pg.helm-values.yaml
	echo "# This file is generated. Do not edit manually." > $@
	cat cloud-native-pg.template.yaml >> $@
	sed 's/^/    /' cloud-native-pg.helm-values.yaml >> $@
	sed 's/^ *$$//' $@ > $@.tmp
	mv $@.tmp $@

immich.yaml: immich.template.yaml immich.helm-values.yaml
	echo "# This file is generated. Do not edit manually." > $@
	cat immich.template.yaml >> $@
	sed 's/^/    /' immich.helm-values.yaml >> $@
	sed 's/^ *$$//' $@ > $@.tmp
	mv $@.tmp $@

nfs-subdir-external-provisioner.yaml: nfs-subdir-external-provisioner.template.yaml nfs-subdir-external-provisioner.helm-values.yaml
	echo "# This file is generated. Do not edit manually." > $@
	cat nfs-subdir-external-provisioner.template.yaml >> $@
	sed 's/^/    /' nfs-subdir-external-provisioner.helm-values.yaml >> $@
	sed 's/^ *$$//' $@ > $@.tmp
	mv $@.tmp $@

pdfding.yaml: pdfding.template.yaml pdfding.helm-values.yaml
	echo "# This file is generated. Do not edit manually." > $@
	cat pdfding.template.yaml >> $@
	sed 's/^/    /' pdfding.helm-values.yaml >> $@
	sed 's/^ *$$//' $@ > $@.tmp
	mv $@.tmp $@
