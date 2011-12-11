EMACS = emacs

ELFILES = $(wildcard src/*.el)
ELCFILES = $(ELFILES:.el=.elc)
AUTOLOADS = src/hs-site-file.el

BATCH=$(EMACS) -batch -q -no-site-file -L src -L lib -L lib/auto-complete-1.3.1

all: $(AUTOLOADS) $(ELCFILES)

src/%.elc: src/%.el
	@echo [C] $<
	@$(BATCH) -f batch-byte-compile $<

$(AUTOLOADS): $(ELFILES)
	[ -f $@ ] || echo '' >$@
	$(BATCH) --eval '(setq generated-autoload-file "'`pwd`'/$@")' -f batch-update-autoloads "src"
# emacs generates this temporary file, so just nuke it...
	@rm -f $(AUTOLOADS)~

clean:
	rm -rf $(AUTOLOADS) $(ELCFILES)
