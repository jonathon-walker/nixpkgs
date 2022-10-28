{
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;

    stdlib = ''
      use_gvm() {
        source $HOME/.gvm/scripts/gvm
        gvm use "$1" >/dev/null
      }

      use_nvm() {
        export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
        nvm use "$1" >/dev/null
      }
    '';
  };
}
