{
  description = "A home-manager/nix-darwin configuration";
  inputs = {
    dotfiles.url = "git+https://git.sr.ht/~jsoo/dotfiles?ref=release";
    flake-compat = {
      flake = false;
      url = "github:edolstra/flake-compat";
    };
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url =
      "github:NixOS/nixpkgs/67e5945d357ffa2d9bf7aa40fa59ddfd99513f12";
    home-manager = {
      url =
        "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    darwin = {
      url = "git+https://github.com/jsoo1/nix-darwin?ref=testing";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { self, dotfiles, nixpkgs, flake-utils, home-manager, darwin, ... }:
    let
      overlays = import ./my-emacs.nix ++ import ./restream.nix;
      all-systems = flake-utils.lib.eachSystem [ "x86_64-linux" "x86_64-darwin" ]
        (system:
          let packages = import nixpkgs { inherit system overlays; }; in
          {
            # Useful for the following nix repl scenario to replace `nix repl pin.nix`:
            # $ nix repl
            # > fl = builtins.getFlake "*this $PWD here*"
            # > :b fl.packages.x86_64-darwin.ncurses
            inherit packages;
          }
        );
    in
    rec {
      inherit (all-systems) packages;

      devShell.x86_64-linux =
        let pkgs = import nixpkgs {
          inherit overlays;
          system = "x86_64-linux";
        };
        in
        pkgs.mkShell {
          buildInputs = [
            (pkgs.writeShellScriptBin "john-home-activation"
              "${homeConfigurations.john.activationPackage}/activate")
          ];
          shellHook = "john-home-activation && exit 0";
        };

      darwinConfigurations.johhsoo = darwin.lib.darwinSystem
        {
          system = "x86_64-darwin";
          modules = [
            ({ pkgs, ... }: {
              nixpkgs = { inherit overlays; };
            })
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.users."johh.soo" = import ./home.nix;
              home-manager.extraSpecialArgs = { inherit dotfiles; };
            }
            ./darwin.nix
          ];
        };

      homeConfigurations.john =
        let
          system = "x86_64-linux";
          pkgs = import nixpkgs { inherit system overlays; };
        in
        home-manager.lib.homeManagerConfiguration {
          inherit system pkgs;
          username = "john";
          homeDirectory = "/home/john";
          configuration = ./home.nix;
          extraSpecialArgs = {
            inherit dotfiles;
          };
        };
    };
}
