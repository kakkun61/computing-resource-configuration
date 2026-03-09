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
