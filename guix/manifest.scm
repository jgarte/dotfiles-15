(use-modules (gnu packages))

(define languages
  '("agda"
    "cedille"
    "coq"
    "idris"))

(define utilities
  '("aspell"
    "aspell-dict-en"
    "cups"
    "direnv"
    "docker-cli"
    "exa"
    "fd"
    "fish"
    "fzy"
    "gdb"
    "global"
    "gnutls"
    "make"
    "pijul"
    "pinentry"
    "ripgrep"
    "rlwrap"
    "shellcheck"
    "strace"
    "time"
    "tlsdate"
    "tokei"
    "tmux"
    "unzip"))

(define browsers
  '("icecat"
    "lynx"
    "ungoogled-chromium"))

(define desktop-tools
  '("alacritty"
    "alsa-utils"
    "compton"
    "dbus"
    "dunst"
    "freecad"
    "garcon"
    "libnotify"
    "my-dmenu"
    "pulseaudio"))

(define fonts
  '("mkfontdir"
    "mkfontscale"
    "font-dejavu"
    "font-iosevka"
    "font-iosevka-term"
    "font-iosevka-term-slab"))

(define haskell-tools
  '("cabal-install"
    "ghc"
    "ghc-aws-lambda-haskell-runtime"
    "hlint"
    "hoogle"
    "ormolu"
    "stylish-haskell"))

(define rust-tools
  '("racer"
    "rust"
    "rust:cargo"
    "rustfmt"))

(define guile-tools
  '("guile-next"
    "guile3.0-colorized"
    "guile3.0-readline"
    "guile3.0-syntax-highlight"))

(define pdf-tools
  '("texlive"
    "zathura"
    "zathura-pdf-mupdf"))

(define xorg-tools
  '("gcc-toolchain" ;; needed by xmonad
    "ghc-dbus"
    "ghc-xmonad-contrib"
    "setxkbmap"
    "xcape"
    "xclip"
    "xdg-utils"
    "xdotool"
    "xev"
    "xfontsel"
    "xinit"
    "xinput"
    "xlockmore"
    "xmessage"
    "xmobar"
    "xmonad"
    "xrandr"
    "xsetroot"
    "xwallpaper"))

(define emacs-packages
  '("emacs-anzu"
    "emacs-avy"
    "emacs-cmake-mode"
    "emacs-company"
    "emacs-company-coq"
    "emacs-company-math"
    "emacs-counsel-projectile"
    "emacs-csv-mode"
    "emacs-dash"
    "emacs-debbugs"
    "emacs-dhall-mode"
    "emacs-dired-git-info"
    "emacs-diredfl"
    "emacs-docker"
    "emacs-dockerfile-mode"
    "emacs-ediprolog"
    "emacs-elf-mode"
    "emacs-elm-mode"
    "emacs-emmet-mode"
    "emacs-evil"
    "emacs-evil-anzu"
    "emacs-evil-commentary"
    "emacs-evil-escape"
    "emacs-evil-leader"
    "emacs-evil-magit"
    "emacs-evil-org"
    "emacs-evil-surround"
    "emacs-evil-tmux-navigator"
    "emacs-f"
    "emacs-fill-column-indicator"
    "emacs-fish-mode"
    "emacs-flycheck"
    "emacs-flycheck-elm"
    "emacs-flycheck-rust"
    "emacs-geiser"
    "emacs-graphviz-dot-mode"
    "emacs-guix"
    "emacs-haskell-mode"
    "emacs-haskell-snippets"
    "emacs-ibuffer-projectile"
    "emacs-idris-mode"
    "emacs-ivy"
    "emacs-let-alist"
    "emacs-magit"
    "emacs-markdown-mode"
    "emacs-multi-term"
    "emacs-next-no-x"
    "emacs-nix-mode"
    "emacs-nodejs-repl"
    "emacs-projectile"
    "emacs-psc-ide"
    "emacs-racer"
    "emacs-reformatter"
    "emacs-restclient"
    "emacs-rust-mode"
    "emacs-s"
    "emacs-slime"
    "emacs-slime-company"
    "emacs-smartparens"
    "emacs-solarized-theme"
    "emacs-tuareg"
    "emacs-vimrc-mode"
    "emacs-web-mode"
    "emacs-wgrep"
    "emacs-which-key"
    "emacs-xterm-color"
    "emacs-yaml-mode"
    "emacs-yasnippet"
    "ocaml4.07-merlin"
    "proof-general-next"))

(specifications->manifest
 (append
  languages
  utilities
  browsers
  desktop-tools
  fonts
  haskell-tools
  rust-tools
  guile-tools
  pdf-tools
  xorg-tools
  emacs-packages))