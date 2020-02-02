;;; package --- Summary
;;; My not minimal-ish anymore init.el
;;; Commentary:
;;; use like any ol init.el
;;; Code:

(require 'seq)
(defmacro add-to-listq (&rest xs)
  "Add `XS' to `LIST'."
  (cons #'progn
        (seq-reduce (lambda (expr list-val-pair)
                      (cons `(add-to-list (quote ,(car list-val-pair)) ,(cadr list-val-pair)) expr))
                    (seq-partition xs 2)
                    nil)))

(defmacro ->> (&rest body)
  "Thrush combinator for `BODY'."
  (let ((result (pop body)))
    (dolist (form body result)
      (setq result (append form (list result))))))

(defmacro define-prefix-keymap (name &optional docstring &rest bindings)
  "Define a keymap named `NAME' and docstring `DOCSTRING' with many `BINDINGS' at once using `define-key'."
  (cons #'progn
        (cons (if docstring `(defvar ,name ,docstring (make-sparse-keymap))
                `(defvar ,name (make-sparse-keymap)))
              (cons `(define-prefix-command (quote ,name))
                    (seq-reduce (lambda (bindings key-fn)
                                  (cons `(define-key (quote ,name) ,(car key-fn) (function ,(cadr key-fn)))
                                        bindings))
                                (seq-partition bindings 2)
                                `(,name))))))

(defun my-package-install (package)
  "Install `PACKAGE' unless already installed."
  (unless (package-installed-p package)
    (package-install package)))

;; Built in GUI elements
(setq ring-bell-function 'ignore
      initial-scratch-message ""
      vc-follow-symlinks 't)
(setq-default truncate-lines 't)
(add-to-listq
 default-frame-alist '(ns-transparent-titlebar . t)
 default-frame-alist '(font . "Iosevka 18"))
(set-fontset-font "fontset-default" 'unicode "DejaVu Math Tex Gyre")

(defalias 'yes-or-no-p 'y-or-n-p)

(toggle-frame-fullscreen)
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(horizontal-scroll-bar-mode -1)

;; No tabs
(setq-default indent-tabs-mode nil)

;; Cursor
(setq cursor-type 'box)
(blink-cursor-mode 0)

;; Large files
(setq large-file-warning-threshold (* 1024 1024))

;; Mouse
(xterm-mouse-mode 1)
(unless window-system
  (global-set-key (kbd "<mouse-4>") 'scroll-down-line)
  (global-set-key (kbd "<mouse-5>") 'scroll-up-line))

;; Font
(set-face-attribute 'default t :font "Iosevka 18")

;; Custom
(setq custom-file "/dev/null")

;; Tab width
(setq tab-width 4)

;; GC Threshold
(setq gc-cons-threshold 200000000)

;; Package
(require 'package)
(add-to-list 'load-path "~/.emacs.d/private/evil-tmux-navigator")
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
(package-refresh-contents t)
(package-initialize)

;; Path
(setq exec-path '("~/.local/.bin"
                  "/run/setuid-programs"
                  "~/.config/guix/current/bin"
                  "~/.guix-profile/bin"
                  "~/.guix-profile/sbin"
                  "/run/current-system/profile/bin"
                  "/run/current-system/profile/sbin"
                  "~/dotfiles/emacs/"))

(my-package-install 'exec-path-from-shell)
(require 'exec-path-from-shell)
(exec-path-from-shell-initialize)

;; Email
(setq user-mail-address "jsoo1@asu.edu"
      user-full-name "John Soo")

;; Shell
(my-package-install 'multi-term)
(setq shell-file-name "bash")

;; EShell
(add-hook 'emacs-startup-hook
          (lambda ()
            (when (not (display-graphic-p)) (cd default-directory))
            (eshell)))
(setq initial-buffer-choice (lambda () (get-buffer-create "*eshell*"))
      eshell-highlight-prompt nil
      eshell-prompt-function
      (lambda ()
        (concat
         (propertize (eshell/whoami) 'face `(:foreground "#93a1a1"))
         " "
         (propertize (eshell/pwd) 'face `(:foreground "#268bd2"))
         " "
         (propertize (or (magit-get-current-branch) "") 'face `(:foreground "#859900"))
         " "
         (propertize "λ" 'face `(:foreground "#b58900" :weight normal))
         " "))
      eshell-prompt-regexp "^[^λ]* [λ] "
      eshell-banner-message "")

(defun my-side-eshell (props)
  "Pop Eshell in a buffer using window `PROPS'."
  (interactive)
  (with-current-buffer (get-buffer-create eshell-buffer-name)
    (display-buffer-in-side-window (current-buffer) props)
    (eshell-mode))
  (pop-to-buffer eshell-buffer-name))

;; Dired
(add-hook 'dired-mode-hook (lambda ()
                             (auto-revert-mode)
                             (dired-hide-details-mode)))

;; Byte compile
(require 'bytecomp)
(setq byte-compile-warnings t)
(setq byte-compile-error-on-warn nil)

;; Backups, lockfiles, auto-saves, local variables
(setq
 backup-directory-alist `((".*" . "~/.emacs.d/private/backups/"))
 delete-old-versions nil
 create-lockfiles nil
 auto-save-file-name-transforms `((".*" "~/.emacs.d/private/auto-saves/" t))
 enable-local-eval t)

;; Imenu List
(my-package-install 'imenu-list)
(require 'imenu-list)
(setq imenu-list-size 0.2)

;; Winner
(winner-mode t)

;; Fill column indicator
(my-package-install 'fill-column-indicator)
(require 'fill-column-indicator)

;; Evil
(setq evil-want-C-u-scroll t
      evil-disable-insert-state-bindings t
      evil-want-abbrev-expand-on-insert-exit nil) ; somehow needs to happen before any mention of evil mode
(my-package-install 'evil)
(require 'evil)
(my-package-install 'evil-surround)
(require 'evil-surround)
(my-package-install 'evil-commentary)
(require 'evil-commentary)
(my-package-install 'evil-leader)
(require 'evil-leader)
(my-package-install 'evil-escape)
(require 'evil-escape)
(my-package-install 'smartparens)
(require 'smartparens-config)
(require 'navigate)

(evil-mode 1)
(global-evil-surround-mode 1)
(evil-commentary-mode)
(evil-escape-mode)
(setq-default evil-escape-key-sequence "df")
(setq-default evil-escape-unordered-key-sequence 't)
(global-evil-leader-mode)
(smartparens-global-mode 1)

(evil-set-initial-state 'compilation-mode 'normal)
(evil-set-initial-state 'ibuffer-mode 'normal)
(evil-set-initial-state 'package-menu-mode 'normal)
(evil-set-initial-state 'debugger-mode 'emacs)
(evil-set-initial-state 'proced 'normal)
(evil-set-initial-state 'ert-results-mode 'normal)
(evil-set-initial-state 'Info-mode 'normal)
(evil-set-initial-state 'comint-mode 'normal)
(evil-set-initial-state 'org-agenda-mode 'normal)

;; Magit
(my-package-install 'magit)
(my-package-install 'evil-magit)
(require 'evil-magit)
(setq magit-display-buffer-function #'magit-display-buffer-fullframe-status-v1)

;; Projectile
(my-package-install 'projectile)
(my-package-install 'ibuffer-projectile)
(projectile-mode +1)
(setq projectile-completion-system 'ivy
      projectile-indexing-method 'hybrid
      projectile-enable-caching 't
      projectile-project-search-path "~/projects/")
(add-hook 'ibuffer-hook
          (lambda ()
            (ibuffer-projectile-set-filter-groups)
            (unless (eq ibuffer-sorting-mode 'alphabetic)
              (ibuffer-do-sort-by-alphabetic))))

;; Don't always ask me to reload the tags table
(setq tags-revert-without-query 1)

(defun my-projectile-compile-buffer-name (project kind)
  "Get the name for `PROJECT's command `KIND' (`RUN' | `TEST' | `COMPILE')."
  (concat "*" project "-" kind "*"))

(defun my-projectile-command (kind)
  "Do command `KIND' (`RUN' | `TEST' | `COMPILE') the projectile project in a compilation buffer named *`PROJECTILE-PROJECT-NAME'-`KIND'*."
  (interactive)
  (let* ((old-compile-buffer (get-buffer "*compilation*"))
         (buffer-name (my-projectile-compile-buffer-name (projectile-project-name) kind))
         (old-cmd-buffer (get-buffer buffer-name)))
    (when old-compile-buffer (kill-buffer old-compile-buffer))
    (funcall (intern (concat "projectile-" kind "-project")) nil)
    (with-current-buffer (get-buffer "*compilation*")
      (when old-cmd-buffer (kill-buffer old-cmd-buffer))
      (rename-buffer buffer-name))))

(defun my-switch-to-compile-buffer (kind)
  "Switch to compile buffer named *`PROJECTILE-PROJECT-NAME'-`KIND'."
  (switch-to-buffer (get-buffer-create (concat "*" (projectile-project-name) "-" kind "*"))))

;; Dir Locals -- see https://emacs.stackexchange.com/questions/13080/reloading-directory-local-variables
(defun my-projectile-reload-dir-locals ()
  "Reload each buffer with the same `default-directory` as the current buffer's."
  (interactive)
  (dolist (buffer (projectile-project-buffers))
    (with-current-buffer buffer
      (hack-dir-local-variables-non-file-buffer))))

;; Org
(my-package-install 'evil-org)
(require 'evil-org)
(org-babel-do-load-languages 'org-babel-load-languages
                             '((js . t)
                               (haskell . t)
                               (emacs-lisp . t)
                               (sql . t)))
(setq org-todo-keywords
      '((sequence "TODO" "IN-PROGRESS" "|" "DONE" "CANCELLED"))
      counsel-projectile-org-capture-templates
      '(("t" "[${name}] Todo" entry
         (file+headline "${root}/TODOs.org" "Todos")
         "* TODO %?
  %u
  %a")
        ("bt" "[${name}] Note" entry
         (file+headline "${root}/TODOs.org" "Notes")
         "* %?
  %t")))

(with-eval-after-load 'org-agenda-mode
  (progn
    (define-key org-agenda-mode-map (kbd "C-c") org-agenda-mode-map)
    (define-key org-agenda-mode-map (kbd "C-m") #'org-agenda-month-view)
    (define-key org-agenda-mode-map "m" #'org-agenda-month-view)))

(set-face-attribute
 'variable-pitch nil
 :family "Monospace")

;; export
(setq
 org-export-with-author nil
 org-export-with-toc nil
 org-export-with-title nil
 org-export-with-creator nil
 org-export-time-stamp-file nil
 org-html-validation-link nil)

;; Anzu
(my-package-install 'anzu)
(global-anzu-mode)
(setq anzu-cons-mode-line-p 'nil)
(my-package-install 'evil-anzu)
(with-eval-after-load 'evil (require 'evil-anzu))

;; Ivy
(my-package-install 'ivy)
(my-package-install 'counsel)
(my-package-install 'swiper)
(my-package-install 'counsel-projectile)
(my-package-install 'wgrep)
(ivy-mode 1)
(counsel-mode 1)
(setq ivy-use-virtual-buffers t
      ivy-re-builders-alist '((t . ivy--regex-ignore-order)))
(setcdr (assoc 'counsel-M-x ivy-initial-inputs-alist) "")

;; Line numbers
(add-hook 'prog-mode-hook #'display-line-numbers-mode)
(setq-default display-line-numbers-type 'relative)
(global-hl-line-mode +1)

(defun next-line-number (curr)
  "Get the next line number after `CURR'."
  (pcase curr
    ('absolute 'relative)
    ('relative 'nil)
    (_ 'absolute)))

;; Which key
(my-package-install 'which-key)
(require 'which-key)
(which-key-mode)
(setq which-key-idle-delay 0.1)

;; Clipboard
(pcase system-type
  ('gnu/linux (progn (my-package-install 'xclip)
                     (xclip-mode 1)))
  ('darwin (progn (my-package-install 'osx-clipboard)
                  (osx-clipboard-mode +1))))

;; GNUTLS issues
;; Skip v1.3 per https://debbugs.gnu.org/cgi/bugreport.cgi?bug=34341#19
(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")

;; Compilation
(define-key compilation-mode-map (kbd "C-c C-l") #'recompile)
;; Avy
(my-package-install 'avy)

;; OSX Clipboard
(my-package-install 'osx-clipboard)
(osx-clipboard-mode +1)

;; Keybindings
(define-key comint-mode-map (kbd "C-c C-k" ) #'comint-clear-buffer)
(define-key comint-mode-map (kbd "C-d") nil)

;; Vinegar
(define-key evil-normal-state-map "-" #'(lambda () (interactive) (dired ".")))
(define-key dired-mode-map "-" #'dired-up-directory)

;; Swiper
(define-key evil-normal-state-map (kbd "C-s") #'swiper)
(global-set-key (kbd "C-s") 'swiper)
(global-set-key (kbd "M-x") 'counsel-M-x)
(global-set-key (kbd "M-y") 'counsel-yank-pop)
(global-set-key (kbd "C-x C-f") 'counsel-find-file)
(global-set-key (kbd "<f1> f") 'counsel-describe-function)
(global-set-key (kbd "<f1> v") 'counsel-describe-variable)
(global-set-key (kbd "<f1> l") 'counsel-find-library)
(global-set-key (kbd "<f2> i") 'counsel-info-lookup-symbol)
(global-set-key (kbd "<f2> u") 'counsel-unicode-char)

;; Compilation and shell ansi colors
(my-package-install 'xterm-color)
(require 'xterm-color)
(setq compilation-environment '("TERM=xterm-256color"))
(add-hook 'compilation-start-hook
          (lambda (proc)
            ;; We need to differentiate between compilation-mode buffers
            ;; and running as part of comint (which at this point we assume
            ;; has been configured separately for xterm-color)
            (when (eq (process-filter proc) 'compilation-filter)
              ;; This is a process associated with a compilation-mode buffer.
              ;; We may call `xterm-color-filter' before its own filter function.
              (set-process-filter
               proc
               (lambda (proc string)
                 (funcall 'compilation-filter proc
                          (xterm-color-filter string)))))))

;; Flycheck
(my-package-install 'flycheck)
(require 'flycheck)
(global-flycheck-mode)
(add-hook 'flycheck-error-list-mode #'auto-revert-mode)

;; ispell
(setq ispell-program-name "aspell"
      ispell-list-command "--list")

;; Company
(my-package-install 'company)
(add-hook 'after-init-hook 'global-company-mode)
(with-eval-after-load 'company
  (progn
    (global-company-mode)
    (define-key company-active-map (kbd "C-n") 'company-select-next)
    (define-key company-active-map (kbd "C-p") 'company-select-previous)
    (define-key company-search-map (kbd "C-n") 'company-select-next)
    (define-key company-search-map (kbd "C-p") 'company-select-previous)))

;; Indentation
;; Per http://emacsredux.com/blog/2013/03/27/indent-region-or-buffer/
(defun indent-buffer ()
  "Indent the currently visited buffer."
  (interactive)
  (indent-region (point-min) (point-max)))

(defun indent-region-or-buffer ()
  "Indent a region if selected, otherwise the whole buffer."
  (interactive)
  (save-excursion
    (if (region-active-p)
        (progn
          (indent-region (region-beginning) (region-end))
          (message "Indented selected region."))
      (progn
        (indent-buffer)
        (message "Indented buffer.")))))

;; Debbugs
(my-package-install 'debbugs)
(setq debbugs-gnu-all-packages '("emacs" "guix" "guix-patches"))
(setq debbugs-gnu-default-packages '("guix" "guix-patches"))
;; Slightly broken, but hey
(setq debbugs-gnu-mode-map (make-sparse-keymap))
(define-key debbugs-gnu-mode-map (kbd "C-c") debbugs-gnu-mode-map)

;; Restclient
(my-package-install 'restclient)
(add-to-list 'auto-mode-alist '("\\.http\\'" . restclient-mode))

;; Idris mode
(add-to-listq load-path "~/.emacs.d/private/idris-mode")

(byte-compile-file "~/.emacs.d/private/idris-mode/idris-mode.el")
(byte-compile-file "~/.emacs.d/private/idris-mode/idris-ipkg-mode.el")
(byte-compile-file "~/.emacs.d/private/idris-mode/inferior-idris.el")

(require 'idris-mode)
(require 'inferior-idris)
(require 'idris-ipkg-mode)
(setq idris-interpreter-path "/home/john/.guix-profile/bin/idris")

(dolist (f '((idris-active-term-face        "#657b83")
             (idris-semantic-type-face      "#b58900")
             (idris-semantic-data-face      "#dc322f")
             (idris-semantic-function-face  "#859900")
             (idris-semantic-bound-face     "#6c71c4")))
  (set-face-foreground (car f) (cadr f)))

(define-key idris-repl-mode-map (kbd "C-c C-k" ) #'idris-repl-clear-buffer)
(define-key idris-mode-map (kbd "C-c C-k") #'idris-repl-clear-buffer)

;; Emacs Lisp Mode
(with-eval-after-load 'company (add-hook 'emacs-lisp-mode-hook #'company-mode 't))

;; Elm mode
(my-package-install 'flycheck-elm)
(require 'flycheck-elm)
(add-to-list 'load-path "~/.emacs.d/private/elm-mode")
(my-package-install 'f)
(my-package-install 'dash)
(my-package-install 's)
(my-package-install 'let-alist)
(require 'elm-mode)
(setq elm-format-on-save 't
      elm-format-elm-version "0.18"
      elm-package-catalog-root "http://package.elm-lang.org/")
(eval-after-load 'flycheck
  '(add-hook 'flycheck-mode-hook #'flycheck-elm-setup))
(with-eval-after-load 'company-mode (add-to-list 'company-backends 'company-elm))
;; Can't get only elm 18 packages without this hack
(defun elm-package-refresh-contents ()
  "Refresh the package list."
  (interactive)
  (elm--assert-dependency-file)
  (let* ((all-packages (elm-package--build-uri "all-packages?elm-package-version=0.18")))
    (with-current-buffer (url-retrieve-synchronously all-packages)
      (goto-char (point-min))
      (re-search-forward "^ *$")
      (setq elm-package--marked-contents nil)
      (setq elm-package--contents (append (json-read) nil)))))

;; Fish mode
(my-package-install 'fish-mode)

;; JavaScript
(my-package-install 'nodejs-repl)
(require 'nodejs-repl)
(add-hook
 'js-mode-hook
 (lambda nil
   (progn
     (define-key js-mode-map (kbd "C-c C-s") 'nodejs-repl)
     (define-key js-mode-map (kbd "C-c C-c") 'nodejs-repl-send-last-expression)
     (define-key js-mode-map (kbd "C-c C-j") 'nodejs-repl-send-line)
     (define-key js-mode-map (kbd "C-c C-r") 'nodejs-repl-send-region)
     (define-key js-mode-map (kbd "C-c C-l") 'nodejs-repl-load-file)
     (define-key js-mode-map (kbd "C-c C-k") (lambda () (interactive) (with-current-buffer "*nodejs*" (comint-clear-buffer))))
     (define-key js-mode-map (kbd "C-c C-z") 'nodejs-repl-switch-to-repl))))
(setq js-indent-level 4)

;; Proof General
(my-package-install 'proof-general)

;; Coq
(add-hook
 'coq-mode-hook
 (lambda ()
   (set-face-attribute
    'proof-locked-face nil
    :underline nil
    :background "#073642")))

(my-package-install 'company-coq)
(add-hook 'coq-mode-hook #'company-coq-mode)
(setq proof-three-window-mode-policy 'hybrid
      proof-script-fly-past-comments t
      proof-splash-seen t
      company-coq-disabled-features '(hello))

;; Haskell mode
(my-package-install 'haskell-mode)
(my-package-install 'haskell-snippets)
(require 'haskell-interactive-mode)
(require 'haskell-process)
(require 'haskell-snippets)
;; See https://github.com/haskell/haskell-mode/issues/1553#issuecomment-358373643
(setq haskell-process-args-ghci '("-ferror-spans")
      haskell-process-args-cabal-repl '("--ghc-options=-ferror-spans")
      haskell-process-args-stack-ghci
      '("--ghci-options=-ferror-spans" "--no-build" "--no-load")
      haskell-process-args-cabal-new-repl '("--ghc-options=-ferror-spans")
      haskell-process-type 'auto
      haskell-process-log 't
      haskell-interactive-popup-errors nil
      flycheck-haskell-hpack-preference 'prefer-cabal
      safe-local-variable-values
      (append
       '((haskell-stylish-on-save . t)
         (haskell-mode-stylish-haskell-path . "ormolu")
         (haskell-mode-stylish-haskell-args . ("--ghc-opt TypeApplications"))
         (haskell-process-type . cabal-new-repl))
       safe-local-variable-values)
      my-old-haskell-mode-hook haskell-mode-hook)

(add-hook 'haskell-mode-hook
          (lambda ()
            (interactive-haskell-mode)
            (yas-minor-mode-on)
            (flycheck-mode)
            (flycheck-disable-checker 'haskell-ghc)))

(define-key haskell-mode-map (kbd "C-c C-f") 'haskell-mode-stylish-buffer)

;; Agda mode
(load-library (let ((coding-system-for-read 'utf-8))
                (shell-command-to-string "agda-mode locate")))

;; Mercury
(add-to-list 'load-path "~/.emacs.d/private/metal-mercury-mode/")
(require 'metal-mercury-mode)

;; Ocaml
(my-package-install 'tuareg)
(my-package-install 'merlin)
(let ((opam-share (ignore-errors (car (process-lines "opam" "config" "var" "share")))))
  (when (and opam-share (file-directory-p opam-share))
    ;; Register Merlin
    (add-to-list 'load-path (expand-file-name "emacs/site-lisp" opam-share))
    (autoload 'merlin-mode "merlin" nil t nil)
    ;; Automatically start it in OCaml buffers
    (add-hook 'tuareg-mode-hook 'merlin-mode t)
    (add-hook 'caml-mode-hook 'merlin-mode t)
    ;; Use opam switch to lookup ocamlmerlin binary
    (setq merlin-command 'opam)))

;; Purescript
(add-to-list 'load-path "~/.emacs.d/private/purescript-mode")
(require 'purescript-mode-autoloads)
(add-to-list 'Info-default-directory-list "~/.emacs.d/private/purescript-mode/")
(add-to-list 'auto-mode-alist '("\\.purs\\'" . purescript-mode))
(my-package-install 'psc-ide)
(require 'psc-ide)
(add-hook 'purescript-mode-hook
          (lambda ()
            (psc-ide-mode)
            (company-mode)
            (flycheck-mode)
            (turn-on-purescript-indentation)))
(define-key purescript-mode-map (kbd "C-c C-s") 'psc-ide-server-start)
(define-key purescript-mode-map (kbd "C-c C-q") 'psc-ide-server-quit)
(add-hook
 'purescript-mode-hook
 (lambda ()
   (setq-local company-backends
              (append '((company-math-symbols-latex company-latex-commands))
                      company-backends))))

;; Guix
(add-to-list 'auto-mode-alist '("\\.scm\\'" . scheme-mode))
(my-package-install 'geiser)
(add-hook 'scheme-mode-hook #'geiser-mode)
(with-eval-after-load 'geiser-guile
  (add-to-list 'geiser-guile-load-path "~/projects/guix"))
(with-eval-after-load 'yasnippet
  (add-to-list 'yas-snippet-dirs "~/projects/guix/etc/snippets"))
(require 'scheme)
(defvar guile-imenu-generic-expression
  (append '(("Public" "^(define-public\\s-+(?\\(\\sw+\\)" 1)
            ("Functions*" "^(define\\*\\s-+(?\\(\\sw+\\)" 1))
        scheme-imenu-generic-expression)
  "Imenu generic expression for Guile modes.  See `imenu-generic-expression'.")
(add-hook
 'scheme-mode-hook
 (lambda ()
   (setq-local imenu-generic-expression guile-imenu-generic-expression)))

;; Common Lisp
(my-package-install 'slime)
(my-package-install 'slime-company)

;; Rust
(my-package-install 'rust-mode)
(my-package-install 'racer)
(my-package-install 'flycheck-rust)
(add-to-list 'auto-mode-alist '("\\.rs\\'" . rust-mode))
(add-hook 'rust-mode-hook #'racer-mode)
(add-hook 'racer-mode-hook #'eldoc-mode)
(add-hook 'racer-mode-hook #'company-mode)
(require 'rust-mode)
(define-key rust-mode-map (kbd "TAB") #'company-indent-or-complete-common)
(setq
 racer-rust-src-path "~/.guix-profile/lib/rustlib/src/rust/src"
 rust-format-on-save t)
(with-eval-after-load 'rust-mode
  (add-hook 'flycheck-mode-hook #'flycheck-rust-setup))

;; SQL
(my-package-install 'sql)
(setq
 sql-product 'postgres
 sql-connection-alist
 '((vetpro (sql-product 'postgres)
           (sql-port 5432)
           (sql-server "localhost")
           (sql-user "postgres")
           (sql-database "vetpro"))
   (logs (sql-product 'postgres)
            (sql-port 5432)
            (sql-server "localhost")
            (sql-user "postgres")
            (sql-database "countySchemaMigrator")))
 sql-postgres-login-params
 '((user :default "postgres")
   (database :default "vetpro")
   (server :default "localhost")
   (port :default 5432))
 sql-postgres-options
 '("-P" "pager=off" "--tuples-only" "--no-align"))

(with-eval-after-load 'sql
  (progn
    (sql-set-product-feature
     'postgres :prompt-regexp "^.* λ ")
    (define-key sql-mode-map (kbd "C-c C-i") #'sql-connect)
    (define-key sql-mode-map (kbd "C-c C-k") #'(lambda () (interactive)
                                                 (with-current-buffer sql-buffer (comint-clear-buffer))))))

;; Math/TeX
(add-to-list 'load-path "~/.emacs.d/private/company-math")
(require 'company-math)

;; Cedille
(require 'cedille-mode)
(define-key cedille-mode-map (kbd "C-c C-l") #'cedille-start-navigation)
(evil-define-key 'normal cedille-mode-map (kbd "C-c") (se-navi-get-keymap 'cedille-mode))
(add-hook
 'cedille-mode-hook
 (lambda ()
   (setq-local company-backends
              (append '((company-math-symbols-latex company-latex-commands))
                      company-backends))))

;; Dot/Graphviz
(my-package-install 'graphviz-dot-mode)

;; YAML
(my-package-install 'yaml-mode)
(require 'yaml-mode)
(add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-mode))

;; Plist
(add-to-list 'auto-mode-alist '("\\.plist\\'" . xml-mode))

;; Dhall
(my-package-install 'dhall-mode)
(add-to-list 'auto-mode-alist '("\\.dhall\\'" . dhall-mode))

;; Markdown
(my-package-install 'markdown-mode)
(autoload 'markdown-mode "markdown-mode"
  "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))
(autoload 'gfm-mode "markdown-mode"
  "Major mode for editing GitHub Flavored Markdown files" t)
(add-to-list 'auto-mode-alist '("README\\.md\\'" . gfm-mode))

;; Docker
;; dockerfile
(my-package-install 'dockerfile-mode)
(require 'dockerfile-mode)
(add-to-list 'auto-mode-alist '("Dockerfile\\'" . dockerfile-mode))

;; docker management
(my-package-install 'docker)

;; Shellcheck
(add-hook 'sh-mode-hook #'flycheck-mode)

;; Vimrc
(my-package-install 'vimrc-mode)
(require 'vimrc-mode)
(add-to-list 'auto-mode-alist '("\\.vim\\(rc\\)?\\'" . vimrc-mode))

;; CSV
(my-package-install 'csv-mode)
(require 'csv-mode)

;; CMake
(my-package-install 'cmake-mode)
(require 'cmake-mode)

;; ELF
(my-package-install 'elf-mode)
(add-to-list 'auto-mode-alist '("\\.\\(?:a\\|so\\)\\'" . elf-mode))

;; Web mode
(my-package-install 'web-mode)
(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.xml\\'" . web-mode))

;; Emmet
(my-package-install 'emmet-mode)
(require 'emmet-mode)
(setq emmet-move-cursor-between-quotes t)
(add-hook 'css-mode-hook  'emmet-mode)
(add-hook 'web-mode-hook 'emmet-mode)

;; Prolog
(my-package-install 'ediprolog)
(require 'ediprolog)
(add-to-list 'auto-mode-alist '("\\.pro\\'" . prolog-mode))

;; Theme
(my-package-install 'solarized-theme)
(require 'solarized-theme)

(setq
 custom-safe-themes
 '("2809bcb77ad21312897b541134981282dc455ccd7c14d74cc333b6e549b824f3"
   "0598c6a29e13e7112cfbc2f523e31927ab7dce56ebb2016b567e1eff6dc1fd4f"
   "d677ef584c6dfc0697901a44b885cc18e206f05114c8a3b7fde674fce6180879"
   "8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4"
   default))
(load-theme 'solarized-dark)

;; Transparency in terminal
(defun my-make-frame-transparent (frame)
  "Make `FRAME' transparent'."
  (if (or (not (display-graphic-p frame))
	  (string= 'base (daemonp))
          (string= 'term (daemonp)))
      (progn (set-face-background 'default "unspecified-bg" frame)
             (set-face-background 'line-number "#073642" frame))))

(defun my-make-this-frame-transparent ()
  "Make `selected-frame' transparent."
  (interactive)
  (my-make-frame-transparent (selected-frame)))

(my-make-frame-transparent (selected-frame))
(add-hook 'after-make-frame-functions #'my-make-frame-transparent)

(defun on-after-init ()
  "From https://stackoverflow.com/questions/19054228/emacs-disable-theme-background-color-in-terminal# ."
  (unless (or (display-graphic-p (selected-frame))
              (not (string= 'base (daemonp)))
              (not (string= 'term (daemonp))))
    (progn (set-face-background 'default "unspecified-bg" (selected-frame))
           (set-face-background 'line-number "#073642" (selected-frame)))))

(add-hook 'window-setup-hook #'on-after-init)

(if (or (string= 'base (daemonp))
        (string= 'term (daemonp))
        (not (display-graphic-p (selected-frame))))

    (progn (set-face-background 'default "unspecified-bg" (selected-frame))
           (set-face-background 'line-number "#073642" (selected-frame))))

;; Mode Line
(set-face-attribute
 'mode-line nil
 :underline nil
 :overline nil
 :foreground "#839496"
 :background "#073642"
 :box '(:line-width 1 :color "#073642" :style 'unspecified))

(set-face-attribute
 'mode-line-inactive nil
 :overline nil
 :underline nil
 :foreground "#586e75"
 :background "#002b36"
 :box '(:line-width 1 :color "#002b36" :style 'unspecified))

(defun evil-state-foreground (state)
  "The mode line color for evil-state `STATE'."
  (pcase state
    ('normal  "#859900")
    ('insert  "#b58900")
    ('emacs   "#2aa198")
    ('replace "#dc322f")
    ('visual  "#268bd2")
    ('motion  "#2aa198")))

(defun my-flycheck-error-str (n fg)
  "Properties string for a number of errors `N' with foreground color `FG'."
  (propertize (format "%s" n) 'face `(:foreground ,fg)))

(defun my-flycheck-error-format (errors)
  "Format `ERRORS', if there are any of type warning or error."
  (let-alist errors
    `(,(if .error (my-flycheck-error-str .error "#dc322f")
         "")
      " "
      ,(if .warning (my-flycheck-error-str .warning  "#b58900")
         ""))))

(defun my-flycheck-mode-line-status-text ()
  "Get text for the current flycheck state."
  (pcase flycheck-last-status-change
    (`not-checked "")
    (`no-checker "-")
    (`running "*")
    (`errored "!")
    (`finished (my-flycheck-error-format
                (flycheck-count-errors flycheck-current-errors)))
    (`interrupted ".")
    (`suspicious "?")))

(defvar my-mode-line-format
  `(" "
    (:eval (propertize
            (if (string-equal "-" (projectile-project-name))
                (format "%s" evil-state)
              (projectile-project-name))
            'face `(:foreground ,(evil-state-foreground evil-state) :weight bold)))
    "  %b "
    (:eval vc-mode)
    "  "
    (:eval (if (and (featurep 'flycheck) flycheck-mode)
               (my-flycheck-mode-line-status-text)
             ""))
    " "
    (:eval anzu--mode-line-format)))

(setq-default mode-line-format nil)

(defun toggle-mode-line ()
  "Toggle mode-line."
  (interactive)
  (let ((ml (if mode-line-format 'nil my-mode-line-format)))
    (setq mode-line-format ml)
    (setq-default mode-line-format ml)
    (force-mode-line-update t)))

;; Keybindings
(evil-leader/set-leader "<SPC>")

(evil-leader/set-key
  "<SPC>" 'counsel-M-x
  "TAB"'evil-switch-to-windows-last-buffer
  "a" 'my-process-map
  "b" 'my-buffer-map
  "c" 'my-compile-map
  "C" 'my-counsel-map
  "d" 'dired
  "e" 'my-error-map
  "f" 'my-file-map
  "g" 'my-git-map
  "h" 'my-describe-map
  "i" 'my-insert-map
  "j" 'my-jump-map
  "o" 'my-org-map
  "p" 'my-projectile-map
  "q" 'my-quit-map
  "s" 'my-search-map
  "t" 'my-toggle-map
  "w" 'my-window-map
  "x" 'my-text-map
  "y" 'my-yank-map
  "z" 'my-zoom-map
  "'" 'eshell
  "/" 'counsel-projectile-rg)

(define-prefix-keymap my-process-map
  "my process keybindings"
  "d" docker
  "e" gnus
  "g" guix
  "l" list-processes
  "o" org-agenda
  "p" proced)

(define-prefix-keymap my-buffer-map
  "my buffer keybindings"
  "b" ivy-switch-buffer
  "c" (lambda () (interactive) (my-switch-to-compile-buffer "compile"))
  "d" (lambda () (interactive) (kill-buffer (current-buffer)))
  "i" ibuffer
  "m" (lambda () (interactive) (switch-to-buffer (get-buffer-create "*Messages*")))
  "r" (lambda () (interactive) (my-switch-to-compile-buffer "run"))
  "R" revert-buffer
  "s" (lambda () (interactive) (switch-to-buffer (get-buffer-create "*Scratch*")))
  "t" (lambda () (interactive) (my-switch-to-compile-buffer "test")))

(define-prefix-keymap my-compile-map
  "my keybindings for compiling"
  "b" (lambda () (interactive) (pop-to-buffer (get-buffer-create "*compilation*")))
  "c" counsel-compile)

(define-prefix-keymap my-counsel-map
  "my keybindings to counsel"
  "b" counsel-switch-buffer
  "c" counsel-colors-emacs
  "d" counsel-dired
  "g" counsel-git
  "h" counsel-command-history
  "i" counsel-ibuffer
  "m" counsel-minor
  "M" counsel-major
  "p" counsel-projectile
  "v" counsel-set-variable
  "w" counsel-colors-web)

(define-prefix-keymap my-describe-map
  "my describe keybindings"
  "a" counsel-apropos
  "b" describe-bindings
  "c" describe-char
  "f" describe-function
  "F" counsel-describe-face
  "i" counsel-info-lookup-symbol
  "I" info-apropos
  "k" describe-key
  "m" describe-mode
  "s" describe-symbol
  "t" describe-theme
  "w" woman
  "v" describe-variable)

(define-prefix-keymap my-error-map
  "my flycheck keybindings"
  "b" flycheck-buffer
  "n" flycheck-next-error
  "l" flycheck-list-errors
  "p" flycheck-previous-error)

(define-prefix-keymap my-file-map
  "my file keybindings"
  "f" counsel-find-file
  "l" find-file-literally
  "r" counsel-buffer-or-recentf
  "s" save-buffer
  "y" (lambda () (interactive) (kill-new (buffer-file-name (current-buffer)))))

(define-prefix-keymap my-git-map
  "my git keybindings"
  "b" magit-blame
  "c" counsel-git-checkout
  "r" magit-refresh-all
  "s" magit-status
  "l" magit-log-buffer-file)

(define-prefix-keymap my-insert-map
  "my insertion keybindings"
  "c" insert-char
  "u" counsel-unicode-char)

(define-prefix-keymap my-jump-map
  "my jump keybindings"
  "c" avy-goto-char
  "i" counsel-imenu
  "j" avy-goto-char-2
  "l" avy-goto-line
  "o" counsel-org-goto-all
  "t" evil-jump-to-tag
  "=" indent-region-or-buffer)

(define-prefix-keymap my-org-map
  "my org bindings"
  "a" counsel-projectile-org-agenda
  "c" counsel-projectile-org-capture
  "g" counsel-org-goto
  "i" counsel-org-entity
  "t" counsel-org-tag)
(defun switch-project-workspace ()
  "Switch to a known projectile project in a new workspace."
  (interactive)
  (let ((projectile-switch-project-action #'projectile-find-file))
    (projectile-switch-project)))

(define-prefix-keymap my-projectile-map
  "my projectile keybindings"
  "a" counsel-projectile-org-agenda
  "b" counsel-projectile
  "c" (lambda () (interactive) (my-projectile-command "compile"))
  "C" counsel-projectile-org-capture
  "d" counsel-projectile-find-dir
  "D" (lambda () (interactive) (dired (projectile-project-root)))
  "e" projectile-edit-dir-locals
  "f" counsel-projectile-find-file
  "I" projectile-invalidate-cache
  "l" switch-project-workspace
  "o" (lambda () (interactive) (find-file (format "%sTODOs.org" (projectile-project-root))))
  "p" counsel-projectile-switch-project
  "r" (lambda () (interactive) (my-projectile-command "run"))
  "R" my-projectile-reload-dir-locals
  "t" (lambda () (interactive) (my-projectile-command "test"))
  "'" projectile-run-eshell
  "]" projectile-find-tag)

(define-prefix-keymap my-quit-map
  "my quit keybindings"
  "q" save-buffers-kill-terminal)

(define-prefix-keymap my-search-map
  "my searching keybindings"
  "s" swiper)

(define-prefix-keymap my-text-map
  "my text keybindings"
  "d" delete-trailing-whitespace)

(define-prefix-keymap my-toggle-map
  "my toggles"
  "c" (lambda nil () (interactive) (fci-mode (if (bound-and-true-p fci-mode) -1 1)))
  "d" toggle-debug-on-error
  "D" toggle-debug-on-quit
  "f" toggle-frame-fullscreen
  "i" imenu-list-smart-toggle
  "l" toggle-truncate-lines
  "m" toggle-mode-line
  "n" (lambda nil () (interactive) (setq display-line-numbers (next-line-number display-line-numbers)))
  "t" counsel-load-theme
  "w" whitespace-mode)

(define-prefix-keymap my-window-map
  "my window keybindings"
  "/" (lambda nil () (interactive) (progn (split-window-horizontally) (balance-windows-area)))
  "-" (lambda nil () (interactive) (progn (split-window-vertically) (balance-windows-area)))
  "'" (lambda nil () (interactive) (my-side-eshell '((side . right) (slot . 1))) (balance-windows-area))
  "c" make-frame
  "d" (lambda nil () (interactive) (progn (delete-window) (balance-windows-area)))
  "D" delete-frame
  "h" (lambda nil () (interactive) (tmux-navigate "left"))
  "j" (lambda nil () (interactive) (tmux-navigate "down"))
  "k" (lambda nil () (interactive) (tmux-navigate "up"))
  "l" (lambda nil () (interactive) (tmux-navigate "right"))
  "H" evil-window-move-far-left
  "J" evil-window-move-very-bottom
  "K" evil-window-move-very-top
  "L" evil-window-move-far-right
  "m" delete-other-windows
  "r" winner-redo
  "u" winner-undo
  "=" balance-windows-area)

(define-prefix-keymap my-yank-map
  "my yanking keybindings"
  "y" counsel-yank-pop)

(define-prefix-keymap my-zoom-map
  "my zoom/text scaling keybindings"
  "+" text-scale-increase
  "=" text-scale-increase
  "-" text-scale-decrease)

;;; init.el ends here
(put 'proof-frob-locked-end 'disabled nil)
