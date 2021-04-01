(require 'ox-publish)

(setq org-export-with-broken-links t)

(setq org-publish-project-alist
      `(
	("org-notes"
	 :exclude "slides/.*\\|book/.*"
	 :base-directory "./"
	 :base-extension "org"
	 :publishing-directory "../docs/"
	 :recursive t
	 :publishing-function org-html-publish-to-html
	 :headline-levels 4
	 ; :html-head-extra ,my-css
	 ; :html-preamble t
	 ;:html-postamble ,my-postamble
	 )
	("org-static"
	 :exclude "slides/.*\\|book/.*"
	 :base-directory "./"
	 :base-extension "css\\|png\\|jpg\\|gif\\|pdf\\|csv\\|rds\\|zip\\|R\\|Rmd\\|xls\\|xlsx\\|html\\|sav\\|mp4"
	 :publishing-directory "../docs/"
	 :recursive t
	 :publishing-function org-publish-attachment
	 )
	("org" :components ("org-notes" "org-static"))
	))
