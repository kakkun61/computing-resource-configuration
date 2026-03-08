pdfding.yaml: pdfding.template.yaml pdfding.helm-values.yaml
	echo "# This file is generated. Do not edit manually." > $@
	cat pdfding.template.yaml >> $@
	sed 's/^/    /' pdfding.helm-values.yaml >> $@
	sed 's/^ *$$//' $@ > $@.tmp
	mv $@.tmp $@
