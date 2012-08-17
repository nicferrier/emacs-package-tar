# package.el multi-file package install

# These are the variables that are specific to the package
NAME=marmalade-test
VERSION=0.0.1
DOC="A test tarball package."

# Everything beyond here should be generic
REQUIREMENTS=requirements.txt
REQUIREMENTS_TEST=requirements-test.txt
package_parts = $(shell cat build-parts.txt)
PACKAGE=$(NAME)-$(VERSION)
TARBALL=$(PACKAGE).tar 

all: tarball

# Install the tarball in a test package store
test: REQUIREMENTS=$(REQUIREMENTS_TEST)
test: tarball
	emacs -Q --batch -l ./packagedir.el -- $(TARBALL)

# Install the tarball in the user's emacs
install: tarball
	emacs --batch -l ~/.emacs.d/init.el -l ./build.el -- $(TARBALL)

# Really would like this to clean the elc files of the package_parts
clean-elc:
	rm -f *.elc

clean: clean-elc
	rm -rf .elpa
	rm -rf $(TARBALL)
	rm -rf $(PACKAGE) 
	rm -rf $(NAME)-pkg.el
	rm -rf README

tarball: $(TARBALL)

$(TARBALL): $(PACKAGE) $(PACKAGE)/$(NAME)-pkg.el
	tar cf $@ $<

$(PACKAGE): $(package_parts)
	mkdir $@
	cp $(package_parts) $@

$(PACKAGE)/$(NAME)-pkg.el:
	echo "(define-package \"$(NAME)\" \"$(VERSION)\" \"$(DOC)\" `cat $(REQUIREMENTS)`)" > $@

# End
