index.html: home.org
	org-ruby $< > ,$@
	cat head.inc ,$@ tail.inc > $@
	rm -r ,$@


