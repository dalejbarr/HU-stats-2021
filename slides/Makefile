include ../.make_config
emacscmd := emacs --batch -l ../src/org-export-extra-setup.el -l org -l org-re-reveal

DEST := ../$(htmldir)/slides
LNAME := XX_newslides

# find the slide directories
# this is very hacky but it seems to work
# [[ TODO: test case when there are no slide directories available ]]
SDIRS := $(shell find . -maxdepth 2 -mindepth 2 -type f -regextype grep \
	-not -regex "^\./template/.*" \
	-iname index.org \
	| sed 's|\./||' | sed 's|/index.org||')

OSRCS := $(shell find $(SDIRS) -type f -iname index.org \
	| sed 's|\./||')

OTARGS := $(patsubst %.org, %.html, $(OSRCS))

default : $(OTARGS) setup.org rsync

%.html : %.org
	@echo "--- compiling $<..."
	$(emacscmd) $< --eval '(org-re-reveal-export-to-html)'
	@echo "--- DONE."
	@echo ""

rsync :
	rsync -av $(SDIRS) $(DEST)

newslides :
	mkdir $(LNAME)
	cp -rv template/* $(LNAME)/

print :
	@echo $(OTARGS)

clean :
	find $(DEST) -regextype grep \
		-not -regex "^../../$(htmldir)/slides/reveal.js.*" \
		-not -path $(DEST) -delete

cleanlocal :
	rm -f $(OTARGS)
