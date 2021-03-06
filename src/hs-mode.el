;;; hs-mode.el — Haskell editing mode.

;; Copyright (C) 2011 Chris Done

;; For parts taken from haskell-mode:

;; Copyright (C) 2003, 2004, 2005, 2006, 2007, 2008  Free Software Foundation, Inc
;; Copyright (C) 1992, 1997-1998 Simon Marlow, Graeme E Moss, and Tommy Thorn

;; This program is free software: you can redistribute it and/or
;; modify it under the terms of the GNU General Public License as
;; published by the Free Software Foundation, either version 3 of the
;; License, or (at your option) any later version.

;; This program is distributed in the hope that it will be useful, but
;; WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see
;; <http://www.gnu.org/licenses/>.

;;; Commentary:

;;; Code:

(require 'hs-types)

;;;###autoload
(define-derived-mode hs-mode nil "Haskell" ""
  (kill-all-local-variables)
  (make-local-variable 'hs-mode)
  (setq hs-mode t)
  (define-key hs-mode-map (kbd "<backtab>")
    (lambda () (interactive) (funcall unindent-line-function)))
  (use-local-map hs-mode-map)
  (setq major-mode 'hs-mode)
  (setq mode-name "Haskell")
  (set (make-local-variable 'indent-line-function) hs-config-indent-function)
  (set (make-local-variable 'unindent-line-function) hs-config-unindent-function)
  (set (make-local-variable 'font-lock-defaults)
       '(hs-mode-font-lock-keywords t nil nil nil))
  (set (make-local-variable 'comment-start) "-- ")
  (set (make-local-variable 'comment-padding) 0)
  (set (make-local-variable 'comment-start-skip) "[-{]-[ \t]*")
  (set (make-local-variable 'comment-end) "")
  (set (make-local-variable 'comment-end-skip) "[ \t]*\\(-}\\|\\s>\\)")
  (hs-completion)
  (setq hs-imenu-generic-expression
        '(("Functions"  "^\\([a-z].+\\) ::" 1)
          ("Types" "^\\(data \\|newtype \\|type \\)\\([^=]*[^:]\\)=" 2)
          ("Instances" "^instance[ ]+\\(.+?\\)[ ]+\\($\\|where$\\)" 1)))
  (setq imenu-generic-expression hs-imenu-generic-expression))

(defvar hs-mode-font-lock-keywords
  `(;; Comments
    ("[ ]+-- \\(\\^\\|\\*\\) .*" . font-lock-doc-face)
    ("[ ]+-- .*" . font-lock-comment-face)
    ("^-- | .*" . font-lock-doc-face)
    ("^--   .*" . font-lock-doc-face)
    ("^--.*" . font-lock-comment-face)
    ("{- | [[:unibyte:]]+? -}" . font-lock-doc-face)
    ("{- [[:unibyte:]]+? -}" . font-lock-comment-face)
    ("{-# [[:unibyte:]]+? #-}" . font-lock-doc-face)
    ;; Strings
    (,(concat "\\(\\(\"\\|\n[ \t]*\\\\\\)\\([^\"\\\\\n]\\|\\\\.\\)"
              "*\\(\"\\|\\\\[ \t]*$\\)\\|'\\([^'\\\\\n]\\|\\\\.[^'\n]*\\)'\\)")
     . font-lock-string-face)
    ;; Keywords
    (,(format 
       "\\<%s\\>"
       (regexp-opt '("case" "class" "data" "default" "deriving" "do" "else"
                     "if" "import" "in" "infix" "infixl" "infixr" "instance" 
                     "let" "module" "newtype" "of" "then" "type" "where" "as"
                     "qualified" "hiding")))
     . font-lock-keyword-face)
    ;; Constructors and types
    ("\\(\\<[A-Z][A-Za-z0-9_']*\\>\\|\\[\\]\\|()\\)" . font-lock-type-face)
    ;; Function declarations
    ("^[_a-z][A-Za-z0-9_']*" . font-lock-function-name-face)
    ;; Numbers
    ("\\<[0-9]+\\>\\.?[0-9]*" . font-lock-constant-face)
    ;; Operators
    ("[-!#$%&\\*\\+\\./<=>\\?@\\\\^\\|~]+" . font-lock-constant-face)
    ;; Reserved symbols
    (,(regexp-opt '(".." "::" "=" "\\" "|" "<-" "->"
                    "@" "~" "=>") t)
     . font-lock-keyword-face)))

(defvar hs-mode-map
  (let ((map (make-sparse-keymap)))
    map)
  "Haskell mode map.")

(defun hs-mode-newline-same-col ()
  "Make a newline and go to the same column as the current line."
  (interactive)
  (let ((point (point)))
    (let ((start-end
	   (save-excursion
	     (let* ((start (line-beginning-position))
		    (end (progn (goto-char start)
				(search-forward-regexp
				 "[^ ]" (line-end-position) t 1))))
	       (when end (cons start (1- end)))))))
      (if start-end
	  (progn (newline)
		 (insert (buffer-substring-no-properties
			  (car start-end) (cdr start-end))))
	(newline)))))

(defun hs-mode-newline-indent ()
  "Make a newline on the current column and indent on step."
  (interactive)
  (hs-mode-newline-same-col)
  (insert "  "))

;; Taken from haskell-mode.
(defun hs-ident-at-point ()
  "Return the identifier under point, or nil if none found.
May return a qualified name."
  (save-excursion
    (let ((case-fold-search nil))
      (multiple-value-bind (start end)
          (if (looking-at "\\s_")
              (values (progn (skip-syntax-backward "_") (point))
                      (progn (skip-syntax-forward "_") (point)))
            (values
             (progn (skip-syntax-backward "w'")
                    (skip-syntax-forward "'") (point))
             (progn (skip-syntax-forward "w'") (point))))
        ;; If we're looking at a module ID that qualifies further IDs, add
        ;; those IDs.
        (goto-char start)
        (while (and (looking-at "[[:upper:]]") (eq (char-after end) ?.)
                    ;; It's a module ID that qualifies further IDs.
                    (goto-char (1+ end))
                    (save-excursion
                      (when (not (zerop (skip-syntax-forward
                                         (if (looking-at "\\s_") "_" "w'"))))
                        (setq end (point))))))
        ;; If we're looking at an ID that's itself qualified by previous
        ;; module IDs, add those too.
        (goto-char start)
        (if (eq (char-after) ?.) (forward-char 1)) ;Special case for "."
        (while (and (eq (char-before) ?.)
                    (progn (forward-char -1)
                           (not (zerop (skip-syntax-backward "w'"))))
                    (skip-syntax-forward "'")
                    (looking-at "[[:upper:]]"))
          (setq start (point)))
        ;; This is it.
        (buffer-substring-no-properties start end)))))

(defun hs-mode-space-info ()
  "Do something useful on space, some cases type info, other cases filling out syntax."
  (interactive)
  (if (or (hs-mode-in-string-p) (hs-mode-in-comment-p))
      (insert " ")
      (progn (insert " ")
             (backward-char)
             (let ((ident (hs-ident-at-point)))
               (cond ((and (string= ident "if") hs-config-clever-ifs)
                      (backward-kill-word 1)
                      (hs-insert-if))
                     (t
                      (forward-char)
                      (when (and (stringp ident) (not (string= "" ident)))
                        (hs-process-info-of-passive-interactive ident))))))))

(defun hs-mode-in-string-p ()
  "Are we in a string? This is a bit of a cheeky trick, but it should be quite reliable."
  (eq (get-text-property 0 'face (buffer-substring (max (point-min) (1- (point))) (min (point-max) (1+ (point)))))
      'font-lock-string-face))

(defun hs-mode-in-comment-p ()
  "Are we in a comment? Again, cheeky trick."
  (let ((face (get-text-property 0 'face (buffer-substring (max (point-min) (1- (point))) (min (point-max) (1+ (point)))))))
    (or (eq face 'font-lock-comment-face)
        (eq face 'font-lock-doc-face))))

(defun hs-mode-insert-at-top (s)
  "Insert some string at the top of the line."
  (goto-char (point-min))
  (insert (format "%s\n" s)))

(defun hs-mode-insert-language-extension ()
  "Choose a language extension and insert it at the top of the file."
  (interactive)
  (hs-mode-insert-at-top 
   (format "{-# LANGUAGE %s #-}"
           (ido-completing-read "Extension: " hs-completion-ghc-extensions))))

(defun hs-mode-bring-interactive-mode ()
  "Bring up the interactive mode for this project."
  (interactive)
  (let ((project (hs-project)))
    (delete-other-windows)
    (split-window-horizontally)
    (switch-to-buffer-other-window
     (hs-interactive-mode-buffer project))
    (other-window 1)))

(defun hs-insert-if ()
  "Fairly cleverly insert if expressions."
  (interactive)
  (if (not (string-match "^[ ]*$" (buffer-substring-no-properties (line-beginning-position) (point))))
      (let ((in-parens? (save-excursion (backward-char) (looking-at "([ ]*)"))))
        (progn (insert (format "%sif  then  else %s"
                               (if in-parens? "" "(")
                               (if in-parens? "" ")")))
               (backward-word 2)
               (backward-char)))
    (let* ((col (current-column)))
      (insert (format "if\n%s   then \n%s   else"
                      (make-string col ? )
                      (make-string col ? )))
      (backward-word 3)
      (forward-word)
      (insert " "))))

(provide 'hs-mode)
