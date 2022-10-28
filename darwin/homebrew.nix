{ config, lib, ... }: {

  homebrew.enable = true;
  homebrew.onActivation.cleanup = "zap";
  homebrew.global.brewfile = true;

  homebrew.taps = [
    "elastic/tap"
    "homebrew/cask-drivers"
    "homebrew/cask-fonts"
    "homebrew/cask-versions"
    "homebrew/cask"
    "homebrew/core"
    "homebrew/services"
    "nrlquaker/createzap"
    "TomAnthony/brews"
    "warrensbox/tap"
  ];

  # Prefer installing application from the Mac App Store
  homebrew.masApps = { "WireGuard" = 1451685025; };

  # If an app isn't available in the Mac App Store, or the version in the App Store has
  # limitiations, e.g., Transmit, install the Homebrew Cask.
  homebrew.casks = [
    "1password-cli"
    "1password"
    "airtame"
    "amethyst"
    "appcleaner"
    "camunda-modeler"
    "docker"
    "google-chrome"
    "insomnia"
    "iterm2"
    "microsoft-remote-desktop"
    "pgadmin4"
    "slack"
    "spotify"
    "stats"
    "visual-studio-code"
    "vlc"
    "whatsapp"
    "zoom"
  ];

  # For cli packages that aren't currently available for macOS in `nixpkgs`.Packages should be
  # installed in `../home/packages.nix` whenever possible.
  homebrew.brews = [ "filebeat-full" "itermocil" "pyenv" "tfswitch" "tgswitch" ];
}
