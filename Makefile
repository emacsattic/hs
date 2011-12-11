################################################################################
# variables

EMACS = emacs

ELFILES = \
    src/hs-align-imports.el \
    src/hs-cabal-mode.el \
    src/hs-cabal.el \
    src/hs-completion.el \
    src/hs-config.el \
    src/hs-core-mode.el \
    src/hs-errors.el \
    src/hs-faces.el \
    src/hs-ghc.el \
    src/hs-indent-glfsf.el \
    src/hs-indent-hsgm.el \
    src/hs-indent-kb.el \
    src/hs-interactive-mode.el \
    src/hs-lang-en.el \
    src/hs-macros.el \
    src/hs-mode.el \
    src/hs-move-nested.el \
    src/hs-navigate-imports.el \
    src/hs-package.el \
    src/hs-pretty-show.el \
    src/hs-process.el \
    src/hs-show.el \
    src/hs-simple-indent.el \
    src/hs-sort-imports.el \
    src/hs-string.el \
    src/hs-tags.el \
    src/hs-types.el \
    src/hs-ui.el
    # src/hs-project.el
    # src/hs.el

ELCFILES = $(ELFILES:.el=.elc)

AUTOLOADS = src/hs-site-file.el

BATCH=$(EMACS) -batch -q -no-site-file -L src -L lib -L lib/auto-complete-1.3.1

################################################################################
# targets

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

################################################################################
