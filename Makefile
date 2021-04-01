# see .make_config file for course configuration
include .make_config

emacscmd := emacs --batch -l src/org-export-extra-setup.el 

default : deploy

.PHONY : book deploy slides web

deploy : slides web | $(htmldir)
	rsync -av $(htmldir)/ $(server):$(webroot)
	ssh $(server) 'find $(webroot) -type d -exec chmod a+rx {} \;'
	ssh $(server) 'find $(webroot) -type f -exec chmod a+r {} \;'

README.md : README.org
	$(CR) $(emacscmd) README.org -f org-md-export-to-markdown # 2>/dev/null

$(htmldir)/slides : $(htmldir)
	mkdir -p $(htmldir)/slides

$(htmldir)/slides/reveal.js : | $(htmldir)/slides
	wget -O /tmp/rvl.tar.gz https://github.com/hakimel/reveal.js/archive/3.9.2.tar.gz
	mkdir -p $(htmldir)/slides/reveal.js
	tar -C $(htmldir)/slides/reveal.js -xvzf /tmp/rvl.tar.gz --strip-components 1
	rm /tmp/rvl.tar.gz

slides : $(htmldir)/slides/reveal.js | $(htmldir)
	$(CR) make -C slides

web : | $(htmldir)
	$(CR) make -C public

$(htmldir) :
	mkdir $(htmldir)
	touch $(htmldir)/.nojekyll

clean :
	make -C slides clean
	make -C public clean

cleanserver :
	ssh $(server) 'rm -rf $(webroot)'
