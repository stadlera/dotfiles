;;; Generic emacs settings
(setq inhibit-startup-screen t)
(setq initial-frame-alist (quote ((fullscreen . maximized))))
(setq package-selected-packages (quote 
				 (use-package 
				   darcula-theme
				   docker-compose-mode
				   gitlab-ci-mode
				   smart-tabs-mode
				   auctex
				   csv-mode
				   elisp-format
				   auto-complete
				   markdown-mode
				   multiple-cursors
				   cmake-mode
				   dockerfile-mode
				   plantuml-mode
				   yaml-mode
				   ac-math)))

(add-to-list 'default-frame-alist '(font . "Noto Sans Mono-10"))

(delete-selection-mode 1) ; Delete selection when typing instead of appending
(when (version<= "26.0.50" emacs-version )
  (global-display-line-numbers-mode))

(when (>= emacs-major-version 24) 
  (require 'package) 
  (add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t) 
  (package-initialize) 
  (unless package-archive-contents (package-refresh-contents)) 
  (package-install-selected-packages))

(add-to-list 'load-path (concat user-emacs-directory
				(convert-standard-filename "elisp/")))


;(use-package 
;  darcula-theme 
;  :ensure t 
;  :config)

;; Multi Cursor
(global-set-key (kbd "C-c m c") 'mc/edit-lines)

;; Spelling
(setq ispell-program-name "aspell")
(setq ispell-dictionary "english")

;; Smart Tabs
(setq tab-width 4)
(smart-tabs-insinuate 'c++ 'python 'c 'javascript)

;; Additional Modes
(autoload 'pkgbuild-mode "pkgbuild-mode.el" "PKGBUILD mode." t)
(setq auto-mode-alist (append '(("/PKGBUILD$" . pkgbuild-mode)) auto-mode-alist))

;; Auto Indentation for Yanking
(dolist (command '(yank yank-pop)) 
  (eval 
   `(defadvice ,command (after indent-region activate) 
      (and (not current-prefix-arg) 
	   (member major-mode '(emacs-lisp-mode lisp-mode clojure-mode    scheme-mode haskell-mode
						ruby-mode rspec-mode      python-mode c-mode
						c++-mode objc-mode       latex-mode plain-tex-mode)) 
	   (let ((mark-even-if-inactive transient-mark-mode)) 
	     (indent-region (region-beginning) 
			    (region-end) nil))))))

;; Remove indent when killing line at eol
(defun kill-and-join-forward 
    (&optional 
     arg)
  "If at end of line, join with following; otherwise kill line.
Deletes whitespace at join." 
  (interactive "P") 
  (if (and (eolp) 
	   (not (bolp))) 
      (delete-indentation t) 
    (kill-line arg)))
(global-set-key "\C-k" 'kill-and-join-forward)

;;; Mode specific settings

;; Org Mode
(with-eval-after-load 'org       
  (setq org-startup-indented t) ; Enable `org-indent-mode' by default
  (add-hook 'org-mode-hook #'visual-line-mode)
  (setcar (nthcdr 4 org-emphasis-regexp-components) 50))

;; LaTeX
(setq TeX-auto-save t)
(setq TeX-parse-self t)
(setq TeX-master nil)
(setq TeX-save-query nil)
(setq reftex-plug-into-AUCTeX t)
(setq bibtex-dialect 'biblatex)
(add-hook 'LaTeX-mode-hook 'visual-line-mode)
(add-hook 'LaTeX-mode-hook 'flyspell-mode)
(add-hook 'LaTeX-mode-hook 'flyspell-buffer)
(add-hook 'LaTeX-mode-hook 'LaTeX-math-mode)
(add-hook 'LaTeX-mode-hook 'turn-on-reftex)
(add-hook 'LaTeX-mode-hook (lambda()
			     (setq indent-tabs-mode t)))


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(LaTeX-indent-level 4)
 '(LaTeX-item-indent 4)
 '(TeX-brace-indent-level 4)
 '(auth-source-save-behavior nil)
 '(custom-safe-themes
   '("79586dc4eb374231af28bbc36ba0880ed8e270249b07f814b0e6555bdcb71fab" "41c8c11f649ba2832347fe16fe85cf66dafe5213ff4d659182e25378f9cfc183" default))
 '(indent-tabs-mode t)
 '(package-selected-packages '(auctex)))
(setq-default tab-width 4)



(setq LaTeX-indent-environment-list
   (quote
    (("verbatim" current-indentation)
     ("verbatim*" current-indentation)
     ("tabular" LaTeX-indent-tabular)
     ("tabular*" LaTeX-indent-tabular)
     ("align" LaTeX-indent-tabular)
     ("align*" LaTeX-indent-tabular)
     ("array" LaTeX-indent-tabular)
     ("eqnarray" LaTeX-indent-tabular)
     ("eqnarray*" LaTeX-indent-tabular)
     ("lstlisting" ignore)
     ("displaymath")
     ("equation")
     ("equation*")
     ("picture")
     ("tabbing"))))

(setq reftex-bibliography-commands '("bibliography" "nobibliography" "addbibresource"))

;; autocomplete
(require 'auto-complete)
(require 'auto-complete-config)
(ac-config-default)

(require 'ac-math) 
(add-to-list 'ac-modes 'latex-mode)   ; make auto-complete aware of `latex-mode`

(defun ac-LaTeX-mode-setup () ; add ac-sources to default ac-sources
  (setq ac-sources
	(append '(ac-source-math-unicode ac-source-math-latex ac-source-latex-commands)
		ac-sources))
  )
(add-hook 'LaTeX-mode-hook 'ac-LaTeX-mode-setup)
(global-auto-complete-mode t)

(setq ac-math-unicode-in-math-p t)
(ac-flyspell-workaround)

;; CMake
(add-hook 'cmake-mode-hook
          (lambda ()
	    (setq indent-tabs-mode t)
	    (setq tab-width 4)
	    (setq cmake-tab-width 4)))

;; sysuplist
(autoload 'sysuplist-mode "sysuplist-mode.el"
  "Major mode for selection Yaourt updates" t)
(add-to-list 'auto-mode-alist '("/sysuplist$" . sysuplist-mode))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(load-theme 'darcula)

