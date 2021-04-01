SHELL := /bin/bash
include ../.make_config
DEST := ../$(htmldir)

default : 
	emacs --batch -l org \
			-l publish.el \
			index.org \
			--eval='(org-publish-project "org")'

clean :
	find $(DEST) -regextype grep \
		-not -regex '^$(DEST)/book.*' \
		-not -regex '^$(DEST)/slides.*' \
		-not -path $(DEST) \
		-delete
