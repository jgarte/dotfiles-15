let pkgs = import <nixpkgs> { };

in [
  pkgs.haskellPackages.hoogle
  # broken for now
  # pkgs.haskellPackages.idris
  pkgs.alacritty
  pkgs.bashInteractive
  pkgs.bash-completion
  pkgs.cabal-install
  pkgs.checkmake
  pkgs.coq
  pkgs.direnv
  pkgs.exa
  pkgs.fd
  pkgs.fish
  pkgs.fzy
  pkgs.ghcid
  pkgs.global
  pkgs.hlint
  pkgs.htop
  pkgs.jq
  pkgs.ngrok
  pkgs.nixfmt
  pkgs.nodejs-10_x
  pkgs.openvpn
  pkgs.ormolu
  pkgs.pijul
  pkgs.postgresql_11
  pkgs.purescript
  pkgs.qemu
  pkgs.racket-minimal
  pkgs.rage
  pkgs.reattach-to-user-namespace
  pkgs.ripgrep
  pkgs.rustfmt
  pkgs.spago
  pkgs.stylish-haskell
  pkgs.tmux
  pkgs.watch
]
