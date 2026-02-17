LIBDIR := lib
include $(LIBDIR)/main.mk

$(LIBDIR)/main.mk:
ifneq (,$(shell grep "path *= *$(LIBDIR)" .gitmodules 2>/dev/null))
	git submodule sync
	git submodule update --init
else
ifneq (,$(wildcard $(ID_TEMPLATE_HOME)))
	ln -s "$(ID_TEMPLATE_HOME)" $(LIBDIR)
else
	git clone -q --depth 10 -b main \
	    https://github.com/martinthomson/i-d-template $(LIBDIR)
endif
endif

sourcecode: draft-ietf-asdf-instance-information.xml
	kramdown-rfc-extract-sourcecode -tfiles $^

sdfcheck-files: sourcecode Makefile
	mkdir -p sdf-files/sourcecode/sdf
	for file in sourcecode/sdf/*.sdf; do echo $$file; if jq . < $$file >/dev/null 2>/dev/null; then cat $$file; else (echo "{"; cat $$file; echo "}"); fi > sdf-files/$$file-fixed; done

sdfcheck: sdfcheck-files
	for file in sdf-files/sourcecode/sdf/*.sdf-fixed; do echo; echo $$file; cddl formal-syntax-of-sdf.cddl v $$file; done

lists.md: draft-ietf-asdf-instance-information.xml
	kramdown-rfc-extract-figures-tables -trfc $< >$@.new
	if cmp $@.new $@; then rm -v $@.new; else mv -v $@.new $@; fi
