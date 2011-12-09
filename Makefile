all:
	emacs -batch --directory=src/ --directory=lib/ --directory=lib/auto-complete-1.3.1 -f batch-byte-compile src/*.el
