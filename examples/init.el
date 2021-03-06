;; Setup useful settings.
(show-paren-mode t)
(line-number-mode t)
(column-number-mode t)
(size-indication-mode t)
(transient-mark-mode 1)
(delete-selection-mode 1)
(setq-default indent-tabs-mode nil)
(ido-mode t)
(global-font-lock-mode 1)
(setq scroll-step 1)
(fset 'yes-or-no-p 'y-or-n-p)
(menu-bar-mode nil)
(scroll-bar-mode nil)
(tool-bar-mode nil)
(set-language-environment "UTF-8")
(setq inhibit-startup-message t
      inhibit-startup-echo-area-message t)
(put 'erase-buffer 'disabled nil)
(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)

;; Start the load process.
(switch-to-buffer "*Messages*")

;; Load the dependencies.
(message "Loading dependencies...")
(add-to-list 'load-path "lib/")
(add-to-list 'load-path "lib/auto-complete-1.3.1")
(require 'auto-complete)
(require 'auto-complete-etags)
(require 'paredit)
(message "Loaded dependencies.")

;; Load the library.
;; It is assumed you will run this init file in the project root of haskell-emacs.
(message "Loading hs library...")
(add-to-list 'load-path "src/")
(require 'hs)
(message "Load hs library.")

;; Instructions:
(message "Run M-x hs-project-start (that's Alt-x) to start a project.")

(message "Running it automatically for the first time...")
(split-window-horizontally)
(hs-project-start "example")

;; Setup associations with file types.
(add-to-list 'auto-mode-alist (cons "\\.hs\\'" 'hs-mode))
(add-to-list 'auto-mode-alist (cons "\\.cabal\\'" 'hs-cabal-mode))
(add-to-list 'auto-mode-alist '("\\.hcr\\'" . hs-core-mode))

;; Setup key bindings
(add-hook 
 'hs-mode-hook
 (lambda ()
   (interactive)
   ;; Bring up the interactive mode for this project.
   (define-key hs-mode-map (kbd "C-`") 'hs-mode-bring-interactive-mode)

   ;; Space after a symbol shows its info.
   (define-key hs-mode-map (kbd "SPC") 'hs-mode-space-info)
   (define-key hs-interactive-mode-map (kbd "SPC") 'hs-mode-space-info)

   ;; Insert language extensions.
   (define-key hs-mode-map (kbd "C-c e") 'hs-mode-insert-language-extension)

   ;; Build the current Cabal project.
   (define-key hs-mode-map (kbd "C-c C-c") 'hs-cabal-build-interactive)

   ;; Run a cabal command (prompting for which command).
   (define-key hs-mode-map (kbd "C-c c") 'hs-cabal-ido-interactive)
   
   ;; For dependency searching.
   (define-key hs-mode-map (kbd "M-.") 'hs-tags-find)

   ;; Run a script within the project directory.
   ;; E.g., define: (setq hs-config-scripts '("scripts/dothis" "scripts/dothat"))
   (define-key hs-mode-map (kbd "C-c t") 'hs-cabal-script-interactive)

   ;; Get the :type of the current symbol at point.
   (define-key hs-mode-map (kbd "C-c C-t") 'hs-process-type-of-interactive)

   ;; Display the :info of the current symbol at point.
   (define-key hs-mode-map (kbd "C-c C-i") 'hs-process-info-of-interactive)
   
   ;; Load the current file.
   (define-key hs-mode-map (kbd "<f5>")
     (lambda ()
       (interactive)
       (when (buffer-modified-p) (save-buffer))
       (hs-process-load-interactive)))

   ;; Save the current file, updating the etags file.
   (define-key hs-mode-map (kbd "\C-x\C-s")
     (lambda ()
       (interactive)
       (when (buffer-modified-p)
         (save-buffer) (hs-tags-generate-interactive))))

   ;; Go to the same column when hitting ret.
   (define-key hs-mode-map (kbd "<return>") 'hs-mode-newline-same-col)

   ;; Indent one level.
   (define-key hs-mode-map (kbd "C-<return>") 'hs-mode-newline-indent)

   ;; Move the code below the current nesting left one.
   (define-key hs-mode-map (kbd "C-<left>")
     (lambda () (interactive) (hs-move-nested -1)))

   ;; Move the code below the current nesting right one.
   (define-key hs-mode-map (kbd "C-<right>")
     (lambda () (interactive) (hs-move-nested 1)))

   ;; Useful editing features of paredit.
   (define-key hs-mode-map (kbd "\"") 'paredit-doublequote)
   (define-key hs-mode-map (kbd "[") 'paredit-open-square)
   (define-key hs-mode-map (kbd "(") 'hs-open-round)
   (define-key hs-mode-map (kbd "]") 'paredit-close-square)
   (define-key hs-mode-map (kbd ")") 'paredit-close-round)
   (define-key hs-mode-map (kbd "{") 'paredit-open-curly)
   (define-key hs-mode-map (kbd "}") 'paredit-close-curly)
   (define-key hs-mode-map (kbd "M-(") 'paredit-wrap-round)
   (define-key hs-mode-map (kbd "DEL") 'paredit-backward-delete)
   (define-key hs-mode-map (kbd "C-k") 'paredit-kill)

   ;; Jump to the imports.
   (define-key hs-mode-map [f8] 'hs-navigate-imports)

   ;; Sort and re-align the import list.
   (define-key hs-mode-map (kbd "C-c C-.")
     (lambda ()
       (interactive)
       (let ((col (current-column)))
         (hs-sort-imports)
         (hs-align-imports)
         (goto-char (+ (line-beginning-position)
                       col)))))))

;; It's nice to have these globally defined so that you can
;; build/re-build/run scripts related to your project from anywhere.
(global-set-key (kbd "C-c t") 'hs-cabal-script-interactive)
(global-set-key (kbd "C-c C-c") 'hs-process-interrupt-interactive)
(global-set-key (kbd "C-c c") 'hs-cabal-ido-interactive)

(hs)
