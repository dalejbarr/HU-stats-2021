emacscmd := emacs --batch -l org -l org-export-extra-setup.el 
singimg := /home/dalebarr/singimg/talklab-tidy4.sif

index.html : index.org setup.org mods.css
	$(emacscmd) $< --eval '(org-reveal-export-to-html)'

