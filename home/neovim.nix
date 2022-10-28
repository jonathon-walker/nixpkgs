{ config, pkgs, ... }:

{
  # Neovim
  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.neovim.enable
  programs.neovim.enable = true;
  programs.neovim.vimAlias = true;
  programs.neovim.viAlias = true;
  programs.neovim.plugins = with pkgs.vimPlugins; [
    vim-nix
    vim-go
    vim-gitgutter
    vim-airline
    nerdtree
  ];
}
