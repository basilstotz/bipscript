PHONY: all
all: package

.PHONY: package
package:
	@find . -name "*_amd64.deb" -exec rm \{\} \;
	@./bin/package.sh



