# BETA — QUICK TRY

Dependencies are included, so that you can just run the commandline 
and try it on your existing projects without messing with your .emacs.

The brave who can put up with bugs can try:

    $ cabal install hasktags
    $ emacs -nw -Q -l examples/init.el

See examples/init.el for example bindings. 

# CONTRIBUTING

**Feedback**

* [Milestones are here.](https://github.com/chrisdone/haskell-emacs/issues/milestones)
* I also maintain the TODO/DONE in this README.md.
* [Create issues here.](https://github.com/chrisdone/haskell-emacs/issues)

**Developing**

* Patches welcome, but do it in a dev branch, not the master branch.
* Please make small, isolated patches and preferably open a
  ticket and associate your commit(s) with the ticket, or a pull request,
  so that we have a history trace.
* Make sure your patches work with `emacs -Q -l examples/init.el`,
  this is a good test to check you're not making any assumptions and
  devs and users can still try and test easily.

Architecture-wise, your main points of interest are:

* [hs.el](https://github.com/chrisdone/haskell-emacs/blob/master/src/hs.el)
* [hs-types.el](https://github.com/chrisdone/haskell-emacs/blob/master/src/hs-types.el)
* [hs-process.el](https://github.com/chrisdone/haskell-emacs/blob/master/src/hs-process.el)
* [hs-cabal.el](https://github.com/chrisdone/haskell-emacs/blob/master/src/hs-cabal.el)
* [hs-config.el](https://github.com/chrisdone/haskell-emacs/blob/master/src/hs-config.el)
* [hs-interactive-mode.el](https://github.com/chrisdone/haskell-emacs/blob/master/src/hs-interactive-mode.el)
* [hs-mode](https://github.com/chrisdone/haskell-emacs/blob/master/src/hs-mode.el)
* [hs-project](https://github.com/chrisdone/haskell-emacs/blob/master/src/hs-project.el)

Most things start in hs-mode, hs-interactive-mode and hs-process.

# DONE

* GHC core mode
* Figuring out project from .cabal file
* Named sessions
* Collapsed/reduced error messages.
* Multi-line expressions
* Cabal build/configure/upload/etc
* Type of symbol at point based on active GHCi session
* Completion based on current module
* Completion based on whole project
* Jump to definition
* Go to error/warning line and column
* In-console completion
* Automatic synchronization with GHCi session (via cabal-dev)
* Sort imports alphabetically
* Align imports up nicely
* Cabal file editing
* Cabal-dev local-repository support
* Language/option/keyword completion
* Move nested blocks of code around
* Jump to/back-from import list for quick editing
* Type of symbol at point (non-local)
* Type error handling (in REPL, brings up an error buffer)
* Auto-insert LANGUAGE pragmas based on GHCi errors
* Meagre imenu support
* Creation of base Cabal projects
* Preliminary loading of files in GHCi with a separate GHCi session,
  this avoids losing type information on a failed compile
* Show-based value inspection
* Module awareness
* Indentation that doesn't suck
* Cabal integration
  * Configuration
  * Interactive creation/management of Cabal file

# TODO — EASY / TRIVIALLY SPECIFIED

* Extraction of types from docs, perhaps pilfer from haskell-mode.
* Hugs support.  Might "just work" with some tweaks to output scanning.
* Maybe pilfer some module scanning stuff from inf-haskell.
* Cabal integration
  * Automatic dependency inserting
* Source code editing
  * Haskell-aware code-folding
  * Documentation of symbol at point
* Module import-export awareness
  * Completion based on:
    * imported modules
    * installed modules with automatic importation and Cabal-file dependency adding
  * Automatic importation and de-importation of modules for used symbols
  * Hoogle search support
* Automake/correctness checking
  * Compilation on an interval
  * On-the-fly hint suggestions
* Documentation browsing
  * Ability to browse Haddock documentation inside Emacs (possibility for texinfo here)

# TODO — NOT SURE / TRICKY / NONTRIVIALLY SPECIFIED

* GHCi interaction
  * Syntax-highlighted prompt
  * Debugger tracebacks
* Source code editing
  * Truly syntax-aware editing
  * Binding tracking
  * Syntax-aware indentation choices
  * Inability to write syntactically incorrect code
  * Type of symbol at point (local)
