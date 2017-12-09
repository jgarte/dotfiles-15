(defun dotspacemacs/emacs-custom-settings ()
  "Emacs custom settings.
This is an auto-generated function, do not modify its content directly, use
Emacs customize menu instead.
This function is called at the very end of Spacemacs initialization."
  (custom-set-variables
   ;; custom-set-variables was added by Custom.
   ;; If you edit it by hand, you could mess it up, so be careful.
   ;; Your init file should contain only one such instance.
   ;; If there is more than one, they won't work right.
   '(helm-dash-docsets-path "~/.local/Zeal/docsets")
   '(package-selected-packages
     (quote
      (zeal-at-point yapfify yaml-mode xterm-color ws-butler winum which-key wgrep web-mode web-beautify volatile-highlights vimrc-mode vi-tilde-fringe vala-snippets vala-mode uuidgen use-package twittering-mode treemacs-projectile treemacs-evil treemacs pfuture toml-mode toc-org thrift tagedit systemd symon string-inflection stan-mode sql-indent spaceline powerline smex smeargle slime-company slime slim-mode slack circe oauth2 websocket shen-elisp shell-pop scss-mode scad-mode sayid sass-mode restart-emacs realgud test-simple loc-changes load-relative ranger rainbow-delimiters racer qml-mode pyvenv pytest pyenv-mode py-isort pug-mode psci purescript-mode psc-ide proof-general powershell popwin pkgbuild-mode pip-requirements persp-mode pcre2el password-generator paradox ox-reveal orgit org-projectile org-category-capture org-present org-pomodoro org-download org-bullets org-brain open-junk-file ob-restclient ob-http nix-mode nginx-mode nand2tetris multi-term mu4e-maildirs-extension mu4e-alert move-text mmm-mode matlab-mode markdown-toc markdown-mode magit-gitflow macrostep lorem-ipsum logcat livid-mode skewer-mode live-py-mode linum-relative link-hint kivy-mode julia-mode js2-refactor js2-mode js-doc js-comint ivy-purpose window-purpose imenu-list ivy-hydra intero insert-shebang info+ indent-guide impatient-mode simple-httpd idris-mode prop-menu ibuffer-projectile hy-mode hungry-delete htmlize hoon-mode hlint-refactor hl-todo hindent highlight-parentheses highlight-numbers parent-mode highlight-indentation hide-comnt help-fns+ helm-make haskell-snippets haml-mode groovy-mode graphviz-dot-mode gradle-mode google-translate golden-ratio gnuplot gitignore-mode gitconfig-mode gitattributes-mode git-timemachine git-messenger git-link git-gutter-fringe+ git-gutter-fringe fringe-helper git-gutter+ git-gutter gh-md ggtags fuzzy fsharp-mode company-quickhelp flyspell-correct-ivy flyspell-correct flycheck-rust flycheck-pos-tip pos-tip flycheck-haskell flycheck-elm flycheck-bashate flx-ido flx fish-mode fill-column-indicator fancy-battery eyebrowse expand-region exec-path-from-shell evil-visualstar evil-visual-mark-mode evil-unimpaired evil-tutor evil-surround evil-snipe evil-search-highlight-persist evil-org org-plus-contrib evil-numbers evil-nerd-commenter evil-mc evil-matchit evil-magit magit git-commit with-editor evil-lisp-state evil-lion evil-indent-plus evil-iedit-state iedit evil-exchange evil-escape evil-ediff evil-cleverparens smartparens evil-args evil-anzu anzu evil goto-chg undo-tree eshell-z eshell-prompt-extras esh-help erlang erc-yt erc-view-log erc-social-graph erc-image erc-hl-nicks emojify ht emoji-cheat-sheet-plus emmet-mode elm-mode elisp-slime-nav editorconfig ebuild-mode dumb-jump dockerfile-mode docker json-mode tablist magit-popup docker-tramp json-snatcher json-reformat disaster diminish diff-hl define-word dante flycheck dactyl-mode cython-mode csv-mode counsel-projectile projectile counsel-dash helm-dash counsel swiper ivy company-web web-completion-data company-tern dash-functional tern company-statistics company-shell company-restclient restclient know-your-http-well company-nixos-options nixos-options company-ghci company-ghc ghc haskell-mode company-emoji company-coq company-math math-symbol-lists company-cabal company-c-headers company-auctex company-anaconda company common-lisp-snippets column-enforce-mode coffee-mode cmm-mode cmake-mode cmake-ide levenshtein clojure-snippets clojure-cheatsheet helm helm-core clojars request-deferred request deferred clj-refactor hydra inflections edn multiple-cursors paredit peg clean-aindent-mode clang-format cider-eval-sexp-fu eval-sexp-fu highlight cider spinner queue pkg-info clojure-mode epl cargo rust-mode browse-at-remote bind-map bind-key auto-yasnippet yasnippet auto-highlight-symbol auto-dictionary auto-compile packed auctex async arduino-mode anaconda-mode pythonic f dash s alert log4e gntp aggressive-indent adaptive-wrap ace-window ace-link avy ac-ispell auto-complete popup)))
   '(tramp-syntax (quote default) nil (tramp)))
  (custom-set-faces
   ;; custom-set-faces was added by Custom.
   ;; If you edit it by hand, you could mess it up, so be careful.
   ;; Your init file should contain only one such instance.
   ;; If there is more than one, they won't work right.
   '(company-tooltip-common ((t (:inherit company-tooltip :weight bold :underline nil))))
   '(company-tooltip-common-selection ((t (:inherit company-tooltip-selection :weight bold :underline nil))))
   '(spaceline-highlight-face ((t (:inherit (quote mode-line) :foreground "#3E3D31" :background "DarkGoldenrod2"))))
   '(spaceline-modified ((t (:inherit (quote mode-line) :foreground "#3E3D31" :background "SkyBlue2"))))
   '(spaceline-read-only ((t (:inherit (quote mode-line) :foreground "#3E3D31" :background "plum3"))))
   '(spacemacs-emacs-face ((t (:inherit (quote mode-line) :foreground "#3E3D31" :background "SkyBlue2"))))
   '(spacemacs-evilified-face ((t (:inherit (quote mode-line) :foreground "#3E3D31" :background "LightGoldenrod3"))))
   '(spacemacs-hybrid-face ((t (:inherit (quote mode-line) :foreground "#222226" :background "SkyBlue2"))))
   '(spacemacs-insert-face ((t (:inherit (quote mode-line) :foreground "#3E3D31" :background "chartreuse3"))))
   '(spacemacs-motion-face ((t (:inherit (quote mode-line) :foreground "#3E3D31" :background "plum3"))))
   '(spacemacs-normal-face ((t (:inherit (quote mode-line) :foreground "#3E3D31" :background "DarkGoldenrod2"))))
   '(spacemacs-replace-face ((t (:inherit (quote mode-line) :foreground "#3E3D31" :background "chocolate"))))
   '(spacemacs-visual-face ((t (:inherit (quote mode-line) :foreground "#3E3D31" :background "gray"))))))
