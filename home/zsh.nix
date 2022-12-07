{ config, pkgs, ... }: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableAutosuggestions = true;

    shellAliases = {
      k = "kubectl";
      rg = "rg --hidden";
      tzsyd = "sudo systemsetup -settimezone Australia/Sydney";
    };

    plugins = with pkgs; [
      {
        name = "powerlevel10k";
        src = "${zsh-powerlevel10k}/share/zsh-powerlevel10k";
        file = "powerlevel10k.zsh-theme";
      }
      {
        name = "powerlevel10k-config";
        src = lib.cleanSource ../configs;
        file = "p10k.zsh";
      }
      {
        name = "zsh-nix-shell";
        file = "nix-shell.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "chisui";
          repo = "zsh-nix-shell";
          rev = "v0.5.0";
          sha256 = "0za4aiwwrlawnia4f29msk822rj9bgcygw6a8a6iikiwzjjz0g91";
        };
      }
    ];

    initExtraFirst = ''
      source $HOME/.gvm/scripts/gvm
    '';

    initExtra = ''
      export NVM_DIR="$HOME/.nvm"
      [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
      [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
    '';
  };
}
