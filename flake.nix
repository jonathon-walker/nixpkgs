{
  description = "Nix configurations";

  inputs = {
    nixpkgs = { url = "github:NixOS/nixpkgs/nixpkgs-22.05-darwin"; };

    nixpkgs-unstable = { url = "github:NixOS/nixpkgs/nixpkgs-unstable"; };

    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    flake-utils = { url = "github:numtide/flake-utils"; };
  };

  outputs = inputs@{ self, darwin, nixpkgs, home-manager, flake-utils, ... }:
    let
      inherit (darwin.lib) darwinSystem;
      inherit (inputs.nixpkgs-unstable.lib)
        attrValues makeOverridable optionalAttrs singleton;

      # Configuration for `nixpkgs`
      nixpkgsConfig = {
        config = { allowUnfree = true; };
        overlays = attrValues self.overlays ++ [
          # Sub in x86 version of packages that don't build on Apple Silicon yet
          (final: prev:
            (optionalAttrs (prev.stdenv.system == "aarch64-darwin") {
              inherit (final.pkgs-x86) idris2;
            }))
        ];
      };

      homeManagerStateVersion = "22.11";

      primaryUserInfo = rec {
        username = "jonathon";
        fullName = "Jonathon Walker";
        email = "jonathonwalker93@gmail.com";
        nixConfigDirectory = "/Users/${username}/.config/nixpkgs";
      };

      nixDarwinCommonModules = attrValues self.darwinModules ++ [
        home-manager.darwinModules.home-manager
        ({ config, ... }:
          let inherit (config.users) primaryUser;
          in {
            nixpkgs = nixpkgsConfig;

            users.users.${primaryUser.username} = {
              name = "${primaryUser.username}";
              home = "/Users/${primaryUser.username}";
            };

            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
            home-manager.verbose = true;

            home-manager.users.${primaryUser.username} = {
              imports = attrValues self.homeManagerModules;
              home.stateVersion = homeManagerStateVersion;
              home.userInfo = primaryUser;
            };

            # Add a registry entry for this flake
            nix.registry.my.flake = self;
          })
      ];

    in {
      darwinConfigurations = rec {
        Jonathon-Walker-2 = darwinSystem {
          system = "aarch64-darwin";
          modules = nixDarwinCommonModules ++ [{
            users.primaryUser = primaryUserInfo // {
              email = "jonathon@identitii.com";
            };

            networking.computerName = "Jonathon Walker 2";
            networking.hostName = "Jonathon-Walker-2";
            networking.knownNetworkServices = [ "Wi-Fi" "USB 10/100/1000 LAN" ];
            networking.dns = [ "1.1.1.1" "8.8.8.8" ];
          }];
        };
      };

      overlays = {
        # Overlay useful on Macs with Apple Silicon
        apple-silicon = final: prev:
          optionalAttrs (prev.stdenv.system == "aarch64-darwin") {
            # Add access to x86 packages system is running Apple Silicon
            pkgs-x86 = import inputs.nixpkgs-unstable {
              system = "x86_64-darwin";
              inherit (nixpkgsConfig) config;
            };
          };

        # Overlay to include node packages listed in `./pkgs/node-packages/package.json`
        # Run `nix run my#nodePackages.node2nix -- -14` to update packages.
        nodePackages = _: prev: {
          nodePackages = prev.nodePackages
            // import ./pkgs/node-packages { pkgs = prev; };
        };
      };

      darwinModules = {
        # configuration
        jw-configuration = import ./darwin/configuration.nix;
        jw-homebrew = import ./darwin/homebrew.nix;
        jw-preferences = import ./darwin/preferences.nix;
        jw-environment = import ./darwin/environment.nix;

        # custom modules
        users-primaryUser = import ./modules/darwin/users.nix;
      };

      homeManagerModules = {
        # configuration
        jw-direnv = import ./home/direnv.nix;
        jw-git = import ./home/git.nix;
        jw-neovim = import ./home/neovim.nix;
        jw-packages = import ./home/packages.nix;
        jw-zsh = import ./home/zsh.nix;

        # custom modules
        home-user-info = { lib, ... }: {
          options.home.userInfo = (self.darwinModules.users-primaryUser {
            inherit lib;
          }).options.users.primaryUser;
        };
      };
    } // flake-utils.lib.eachDefaultSystem (system: {
      # Add re-export `nixpkgs` packages with overlays.
      # This is handy in combination with `nix registry add my /Users/malo/.config/nixpkgs`
      legacyPackages = import inputs.nixpkgs-unstable {
        inherit system;
        inherit (nixpkgsConfig) config;
        overlays =
          attrValues { inherit (self.overlays) apple-silicon nodePackages; };
      };
    });
}
