{ config, lib, pkgs, ... }:
let inherit (pkgs.stdenvNoCC) isAarch64 isAarch32;
in {
  nix = {
    binaryCaches = [ 
      "https://cache.nixos.org/"
      "https://devenv.cachix.org"
    ];

    binaryCachePublicKeys =
      [ "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" ];
    trustedUsers = [ "@admin" ];

    configureBuildUsers = true;

    extraOptions = ''
      experimental-features = nix-command flakes
    '' + lib.optionalString (pkgs.system == "aarch64-darwin")
      "	extra-platforms = x86_64-darwin aarch64-darwin\n";
  };

  # Create /etc/bashrc that loads the nix-darwin environment.
  programs.zsh = {
    enable = true;
    shellInit = ''
      eval "$(${config.homebrew.brewPrefix}/brew shellenv)"
    '';
  };

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  # Add ability to used TouchID for sudo authentication
  security.pam.enableSudoTouchIdAuth = true;
}
